Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B1BC367951
	for <lists+netdev@lfdr.de>; Thu, 22 Apr 2021 07:31:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234692AbhDVFbi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 01:31:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229608AbhDVFbi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Apr 2021 01:31:38 -0400
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECD85C06174A
        for <netdev@vger.kernel.org>; Wed, 21 Apr 2021 22:31:03 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id q123-20020a1c43810000b029012c7d852459so3576923wma.0
        for <netdev@vger.kernel.org>; Wed, 21 Apr 2021 22:31:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Mj6C17t14k8TSaVXI56Xodc1slixWpXlM/wm1wQOczs=;
        b=mWiMnrGpxCs6b4Q/Lr3YvCVaw0JCc92ebP+s1T/fqyp96v4ROx+Yb3gUulLBcsdiuu
         D7aOpYhu3nYCxG8vYJlsAKm5zIBcpm1l2/i40C5Vvjs8XQ8g5C9NYD1W6B/y5Gx9crH4
         s9kV0Uigv/vF3q8+e89HsMw0dmdDYwqMnofiulo8eiBbkSu1tT39iOnNGs/57J9ftJ1x
         Mr3wBtjYnn8auneJhhVvSRzJDJFS+04SV96qhzlkvoQ8oxPQQeGvQjzmX1U31GTks/nf
         y3qL8w34HB7lOJKtg2CekqYRiuxznvGa8oWCaz1nkMwP9PpKmdyn2XLVkzh6ZwPuhdBa
         P55g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Mj6C17t14k8TSaVXI56Xodc1slixWpXlM/wm1wQOczs=;
        b=hpMus8Pk0q4q83uxejdoM++ww3HukkAuSjKvrmYUtUw/NtRIlBOR7IwD+dZ7k7z9ru
         Idruo18fJXINERImmkKLgb1E8X1pF2iDjMRv0uxUkajBIZcUlYXINptmyH1MNWqtQTKO
         f0LKHThzuCUkzzyN3llDgJon94ejwNK3qWd2HzF1g9NR4EnVw2PZB8x6UeurWj+MFO/M
         uCcKd8KKgdqNCrBkvliX+GrqhC1ch5lvC+a4dcMyvdUkhWSBMg/bj17W8IEYMUWReXFI
         YxkrSOKSxBInksklNkWt62O9WUKlrTdEPjgw3NG2MqDsoGc4mWIHINvZG9jzm5CTb1Bq
         oSGg==
X-Gm-Message-State: AOAM532x4hmtAMIW9UCfmBlTALF4cufSQMlKvuBmzxLTFImdLJYpTBgv
        SqJPF81VbEQcTsFL+2W8E9F9npA6fqGRPXX4BLo=
X-Google-Smtp-Source: ABdhPJyw3xLjCPKV8CvXdDbDJTn1lxzydyc8GSfb9uksHVrMsetyNIimDtj2csRnGOWcDbTYZ7J1sWjRvJun7ZW2OVw=
X-Received: by 2002:a05:600c:9:: with SMTP id g9mr1803734wmc.134.1619069462769;
 Wed, 21 Apr 2021 22:31:02 -0700 (PDT)
MIME-Version: 1.0
References: <20210420213517.24171-1-drt@linux.ibm.com>
In-Reply-To: <20210420213517.24171-1-drt@linux.ibm.com>
From:   Lijun Pan <lijunp213@gmail.com>
Date:   Thu, 22 Apr 2021 00:30:52 -0500
Message-ID: <CAOhMmr5XayoXS=sJ+9zm68VF+Jn+9qiVvWUrDfq0WGQ6ftKdbw@mail.gmail.com>
Subject: Re: [PATCH V2 net] ibmvnic: Continue with reset if set link down failed
To:     Dany Madden <drt@linux.ibm.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Sukadev Bhattiprolu <sukadev@linux.ibm.com>,
        Thomas Falcon <tlfalcon@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, netdev@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 20, 2021 at 4:37 PM Dany Madden <drt@linux.ibm.com> wrote:
>
> When ibmvnic gets a FATAL error message from the vnicserver, it marks
> the Command Respond Queue (CRQ) inactive and resets the adapter. If this
> FATAL reset fails and a transmission timeout reset follows, the CRQ is
> still inactive, ibmvnic's attempt to set link down will also fail. If
> ibmvnic abandons the reset because of this failed set link down and this
> is the last reset in the workqueue, then this adapter will be left in an
> inoperable state.
>
> Instead, make the driver ignore this link down failure and continue to
> free and re-register CRQ so that the adapter has an opportunity to
> recover.
>
> Fixes: ed651a10875f ("ibmvnic: Updated reset handling")
> Signed-off-by: Dany Madden <drt@linux.ibm.com>
> Reviewed-by: Rick Lindsley <ricklind@linux.ibm.com>
> Reviewed-by: Sukadev Bhattiprolu <sukadev@linux.ibm.com>

One thing I would like to point out as already pointed out by Nathan Lynch is
that those review-by tags given by the same groups of people from the same
company loses credibility over time if you never critique or ask
questions on the list.
