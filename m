Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9A7D425724
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 17:54:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242091AbhJGP4A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 11:56:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233448AbhJGPz7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Oct 2021 11:55:59 -0400
Received: from mail-ua1-x92e.google.com (mail-ua1-x92e.google.com [IPv6:2607:f8b0:4864:20::92e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA541C061570;
        Thu,  7 Oct 2021 08:54:05 -0700 (PDT)
Received: by mail-ua1-x92e.google.com with SMTP id u5so4563870uao.13;
        Thu, 07 Oct 2021 08:54:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=F5NVqTQA2DoIb4u3s4XDfPGuXgE0s3WrhZRf0rXXlRw=;
        b=BEfYKGW04NH8a3rAhO3cItSa6COIvqZ1fflSEM2Olf35HNnOHXgXFZ31Jrgs2HdXnl
         SwjxA31d0hxgmHP+rcBaDotWjikTCRvm1eEpxkYFnsPxFv1wYia6Cd3bsPA05K2VQcbO
         bI80q0LraB9lODblwmKDtKlaIbB5ABSRJJ38AVuLFGd1JJQOzReae7hIE4VyszykQRck
         m76glyYq5NX1hgH2QuVnBykmGMYMEdUPR/Dsb32SN8163U1z9zPGp8x7aD1ssWRMYxjr
         9ixeYtOgGupUGuHp8rJhDqMz1mmNpVKCodXC5zGSI4KnKETEyXNBy3T9X7rCTfHlkQWa
         lpzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=F5NVqTQA2DoIb4u3s4XDfPGuXgE0s3WrhZRf0rXXlRw=;
        b=LsLvQbH4Za2igrmGijoOzg1SjQLUNx4HOLdZDbg/ZhV6pPkBNWym6dWr7Ehz84QUsa
         1FcvepsVfATfhW0XIrnBnP4ooJ0pFz6H91lB8w5bzmVFSenDqZ3OxEQZAPyLbcuIKUSU
         I/4At2VT1z4eWlc/cJy/v3YI1CLchZH6fTdSUtFLOV/5dNXpHh4oegK8nXxzso9zLEA3
         6qwvzIVnxFw2Y4f2hwb0lU67eKexiZ5ouOyZ805DDyUlGu7XrbWAkNXoSKbINk/HTX0p
         MHrqiNZyZRtR8HOPPUsgXw0mgr7/cWVTILIO+SXAu1SN9c+dO1Viq9HUme/5/tIyVA6c
         rOZg==
X-Gm-Message-State: AOAM533XXACttSGsy51yKK8H2RVBbCNlrBDqb6YsuzUiy0V14P8BXu1S
        lGq5wevBS4UGBrswDV3eABMMpimyrOQqvz9XNYk=
X-Google-Smtp-Source: ABdhPJzxKzF0TEdirPjXZN+1CNcfvxMvmgE6JFVmNDF92+MA6OSZi4t0WC4ofPR/ld2456wQL/nm+tKZNxBM9T1idG4=
X-Received: by 2002:ab0:2b13:: with SMTP id e19mr5306343uar.3.1633622044879;
 Thu, 07 Oct 2021 08:54:04 -0700 (PDT)
MIME-Version: 1.0
References: <20211007111713.12207-1-colin.king@canonical.com>
 <CABBYNZKzVtyZ_qO8pvenSLFRdm9aumxD_-Src4VG3UHQa8y+1w@mail.gmail.com> <888C3A95-5410-4B53-8805-4BAE9A9E6010@holtmann.org>
In-Reply-To: <888C3A95-5410-4B53-8805-4BAE9A9E6010@holtmann.org>
From:   Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Date:   Thu, 7 Oct 2021 08:53:54 -0700
Message-ID: <CABBYNZ+rXe9OoEHPjmfh0NUkV+upJc7hS23dE40V12hd6FSwyg@mail.gmail.com>
Subject: Re: [PATCH][next] Bluetooth: use bitmap_empty to check if a bitmap
 has any bits set
To:     Marcel Holtmann <marcel@holtmann.org>
Cc:     Colin King <colin.king@canonical.com>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        kernel-janitors@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Marcel,

On Thu, Oct 7, 2021 at 8:47 AM Marcel Holtmann <marcel@holtmann.org> wrote:
>
> Hi Luiz,
>
> >> The check to see if any tasks are left checks if bitmap array is zero
> >> rather than using the appropriate bitmap helper functions to check the
> >> bits in the array. Fix this by using bitmap_empty on the bitmap.
> >>
> >> Addresses-Coverity: (" Array compared against 0")
> >> Fixes: 912730b52552 ("Bluetooth: Fix wake up suspend_wait_q prematurel=
y")
> >> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> >> ---
> >> net/bluetooth/hci_request.c | 2 +-
> >> 1 file changed, 1 insertion(+), 1 deletion(-)
> >>
> >> diff --git a/net/bluetooth/hci_request.c b/net/bluetooth/hci_request.c
> >> index 209f4fe17237..bad3b9c895ba 100644
> >> --- a/net/bluetooth/hci_request.c
> >> +++ b/net/bluetooth/hci_request.c
> >> @@ -1108,7 +1108,7 @@ static void suspend_req_complete(struct hci_dev =
*hdev, u8 status, u16 opcode)
> >>        clear_bit(SUSPEND_SET_ADV_FILTER, hdev->suspend_tasks);
> >>
> >>        /* Wake up only if there are no tasks left */
> >> -       if (!hdev->suspend_tasks)
> >> +       if (!bitmap_empty(hdev->suspend_tasks, __SUSPEND_NUM_TASKS))
> >>                wake_up(&hdev->suspend_wait_q);
> >> }
> >>
> >> --
> >> 2.32.0
> >
> > I was going to revert this change since it appears wake_up does
> > actually check the wake condition there is no premature wake up after
> > all.
>
> so should I take the patch "Fix wake up suspend_wait_q prematurely=E2=80=
=9D completely out?

Yes, please take it out.

--=20
Luiz Augusto von Dentz
