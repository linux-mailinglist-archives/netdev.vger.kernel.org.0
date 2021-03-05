Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14FF732EFD7
	for <lists+netdev@lfdr.de>; Fri,  5 Mar 2021 17:16:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231258AbhCEQQE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Mar 2021 11:16:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231261AbhCEQPz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Mar 2021 11:15:55 -0500
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE0D1C061756
        for <netdev@vger.kernel.org>; Fri,  5 Mar 2021 08:15:54 -0800 (PST)
Received: by mail-ej1-x630.google.com with SMTP id c10so4500822ejx.9
        for <netdev@vger.kernel.org>; Fri, 05 Mar 2021 08:15:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4Xb9UOY2Gv704gb88GvqIXJCorlDWMU6wr0g3R4KLys=;
        b=iYvuQ4Os3tabOH7OdwSRvUwYplKP8jS7hGpza4luZLaNFt2WLB96jzDnKG+OG46WtD
         RTUQT4Qhjb0fe11zcPjkcF1TPwYMW+N+cvlLRDEKqtIue0Mm231x8Bd1gLXp+xbUtIPG
         ckfuflB0QndyFZyKtw95cWRkmfF38x6/ztGnLfOdFghW1Q1WagxYr/qvQslf6XBRuQsM
         TJS6hNzQh/PEZzI4+L+dbw1KxSF/i+T1TZ84TlbYDwohcdmpB0kRP4n5oYsqv13eZQmC
         phONRhT5uOWG6GF5AGWo8oyef5U7epYq8xjhS7q5462MlK1+FAeQOeRraVUoqKZyWYfv
         Tnww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4Xb9UOY2Gv704gb88GvqIXJCorlDWMU6wr0g3R4KLys=;
        b=FAFVCgpJAylLx1nZ2en97D8uLT8Uz5bdKH9G1h58RiiexH6ILKJknt7W1kx0Xn7Me+
         TPuQSs8rHFshwuCJTigCd2PHQ919hMgPLzOUJ5imG3ldmsnCJr7FMmIntHYpUU3hwoTJ
         mi/biOIIzAIf3MJRei4kkgNBSf1/v5lu7Ut05TIxKCiy2PpSvnpjvrQBzSRY+VXXsI8D
         1+B12SEG1dNoEFP9QkCGax+1csB7xeDet5avRK4PIKj6sxjY0l70wUDvTaCDCxVbuykC
         5L5Fz7EdlxyywMI/ALJN0iLqM+ssMIY6gplZQyhJFggyxCTmwzU8yQj8sWE5lZcdHcq7
         8HVw==
X-Gm-Message-State: AOAM533p7fAwbGtSiSpmzZsqVRDIaLZIWM7ZbKVeQ3EId+HkqRKX1ms/
        gwRnuPuqV2lkXeErcnY6hTrl7KqKS4s=
X-Google-Smtp-Source: ABdhPJz5UJkvqHhyAe3hah/Ij8XdXxUDcWxLONkdlBFlh+48DAqXZArsZ8pYpN7Ou8j8oZP07lcXAQ==
X-Received: by 2002:a17:906:3b99:: with SMTP id u25mr2828711ejf.277.1614960953160;
        Fri, 05 Mar 2021 08:15:53 -0800 (PST)
Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com. [209.85.221.46])
        by smtp.gmail.com with ESMTPSA id d15sm1967095edx.62.2021.03.05.08.15.52
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Mar 2021 08:15:52 -0800 (PST)
Received: by mail-wr1-f46.google.com with SMTP id u14so2708019wri.3
        for <netdev@vger.kernel.org>; Fri, 05 Mar 2021 08:15:52 -0800 (PST)
X-Received: by 2002:a05:6000:1803:: with SMTP id m3mr9809122wrh.50.1614960952213;
 Fri, 05 Mar 2021 08:15:52 -0800 (PST)
MIME-Version: 1.0
References: <20210305123347.15311-1-hxseverything@gmail.com>
 <CA+FuTSc_RDHb8dmMzfwatt89pXsX2AA1--X98pEGkmmfpVs-Vg@mail.gmail.com> <dfde1c9f-cd2d-6e7d-ea3e-58b486a1388b@iogearbox.net>
In-Reply-To: <dfde1c9f-cd2d-6e7d-ea3e-58b486a1388b@iogearbox.net>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Fri, 5 Mar 2021 11:15:15 -0500
X-Gmail-Original-Message-ID: <CA+FuTSfk2HOupSwUfOjsNQBA4Z8HKUgfkQmyTViY5icbt4ujHg@mail.gmail.com>
Message-ID: <CA+FuTSfk2HOupSwUfOjsNQBA4Z8HKUgfkQmyTViY5icbt4ujHg@mail.gmail.com>
Subject: Re: [PATCH bpf-next] selftests_bpf: extend test_tc_tunnel test with vxlan
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Xuesen Huang <hxseverything@gmail.com>,
        David Miller <davem@davemloft.net>, bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Xuesen Huang <huangxuesen@kuaishou.com>,
        Li Wang <wangli09@kuaishou.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 5, 2021 at 11:10 AM Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> On 3/5/21 4:08 PM, Willem de Bruijn wrote:
> > On Fri, Mar 5, 2021 at 7:34 AM Xuesen Huang <hxseverything@gmail.com> wrote:
> >>
> >> From: Xuesen Huang <huangxuesen@kuaishou.com>
> >>
> >> Add BPF_F_ADJ_ROOM_ENCAP_L2_ETH flag to the existing tests which
> >> encapsulates the ethernet as the inner l2 header.
> >>
> >> Update a vxlan encapsulation test case.
> >>
> >> Signed-off-by: Xuesen Huang <huangxuesen@kuaishou.com>
> >> Signed-off-by: Li Wang <wangli09@kuaishou.com>
> >> Signed-off-by: Willem de Bruijn <willemb@google.com>
> >
> > Please don't add my signed off by without asking.
>
> Agree, I can remove it if you prefer while applying and only keep the
> ack instead.

That would be great. Thanks, Daniel!
