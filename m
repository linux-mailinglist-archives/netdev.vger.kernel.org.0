Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F88C21A0FB
	for <lists+netdev@lfdr.de>; Thu,  9 Jul 2020 15:35:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726867AbgGINfX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jul 2020 09:35:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726497AbgGINfX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jul 2020 09:35:23 -0400
Received: from mail-qv1-xf43.google.com (mail-qv1-xf43.google.com [IPv6:2607:f8b0:4864:20::f43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A687C08C5CE
        for <netdev@vger.kernel.org>; Thu,  9 Jul 2020 06:35:23 -0700 (PDT)
Received: by mail-qv1-xf43.google.com with SMTP id m8so915849qvk.7
        for <netdev@vger.kernel.org>; Thu, 09 Jul 2020 06:35:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=po2/Zq3Pp53OJsC+imtAcVCu/PKOJVjfky0fKrZxNFM=;
        b=EyfDar7HsnavxdJ4viPlKBlksmJscjlmVJSDlXGZNtJHnoR4L25RT5zZBCypNz4xH9
         wyCe8zXbtsA3cLaALcSkqgjmT/FD4oB2wZ1jmaK7NYWC0yyme2HepCCPFHO1fcwNedx0
         snq66F3YTv5cc8Hg/rW8lKmJxJDh0DIeOKQpVgivDX352JQ4zo0t16DDt3NVue/AdcB+
         ojDY0b11o63+hI8yIPz8qid9Ww3W0EvodB/3mM1YsvkmIeJLZKNeVsC+NtmTT+GuT8nK
         oUnBvVhMOoo8v7T/76gQBoqQgSDGMcH+/woKqSFR2qvVrSk6Biq0to6g9fmP5gFRs4Mj
         kxkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=po2/Zq3Pp53OJsC+imtAcVCu/PKOJVjfky0fKrZxNFM=;
        b=a/h38/N4rYR//zxnQzfXCtcs1DirBgqFIEdKvHbT27WO00SuDjcZTUQdw713MwG6gr
         ik2ac0z5Aq00zBACzQ9Kb0W/8+vXHLVv/GFLqr6ojn9gcCtXNLlpmkvCU+uDM9zxtcwP
         +DIIpQ5tb3+F4GLI9yASdtPbJvgg83Yt2LUFsLez3nsTeEAv6RXWBoqCJJyXI7t4uHQD
         rLbZy8V688gCrtcXkDLzoXjF4DObmsEk+LjJ/uC6UyWADSQ5knxYXYyGJCu6fANjBfwK
         q8AytW6yT1yrT9rSOrLMy8l37xy0ioTA+V9FThPX+MOvwb7N8p2TVmnpmr3GAvISKoqx
         KG4Q==
X-Gm-Message-State: AOAM530ayrIGRf2G8VHhTH+t+nOD92y0s7X90zF4/8R4g8jJ7cldoWvp
        DwWNIL56E6eASf3/slkPpmERYoUo
X-Google-Smtp-Source: ABdhPJxCUbPnZommJfvUTyR4wPISvAmhg5Nt+uMtq6R7uzbVt5x/s+zY/qbogJCYpwx13HCTxGi7TA==
X-Received: by 2002:a0c:e14d:: with SMTP id c13mr30302450qvl.158.1594301721927;
        Thu, 09 Jul 2020 06:35:21 -0700 (PDT)
Received: from mail-yb1-f175.google.com (mail-yb1-f175.google.com. [209.85.219.175])
        by smtp.gmail.com with ESMTPSA id f54sm4032343qte.76.2020.07.09.06.35.20
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Jul 2020 06:35:20 -0700 (PDT)
Received: by mail-yb1-f175.google.com with SMTP id 2so1018099ybr.13
        for <netdev@vger.kernel.org>; Thu, 09 Jul 2020 06:35:20 -0700 (PDT)
X-Received: by 2002:a25:3610:: with SMTP id d16mr110585753yba.213.1594301719912;
 Thu, 09 Jul 2020 06:35:19 -0700 (PDT)
MIME-Version: 1.0
References: <1594180136-15912-1-git-send-email-tanhuazhong@huawei.com>
 <1594180136-15912-2-git-send-email-tanhuazhong@huawei.com>
 <CA+FuTScYPDhP0NigDgcu+Gpz5GUxttX2htS1NT__pqQOvtsKqw@mail.gmail.com> <aee519de-c793-a2a7-34d1-c18c90080ca6@huawei.com>
In-Reply-To: <aee519de-c793-a2a7-34d1-c18c90080ca6@huawei.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Thu, 9 Jul 2020 09:34:42 -0400
X-Gmail-Original-Message-ID: <CA+FuTSeJMLW=HHrDjenEeinDc6RZTEynjkQWY6cPnOB-FbOTnA@mail.gmail.com>
Message-ID: <CA+FuTSeJMLW=HHrDjenEeinDc6RZTEynjkQWY6cPnOB-FbOTnA@mail.gmail.com>
Subject: Re: [RFC net-next 1/2] udp: add NETIF_F_GSO_UDP_L4 to NETIF_F_SOFTWARE_GSO
To:     tanhuazhong <tanhuazhong@huawei.com>
Cc:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        David Miller <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>,
        linuxarm@huawei.com, Jakub Kicinski <kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 8, 2020 at 10:49 PM tanhuazhong <tanhuazhong@huawei.com> wrote:
>
>
>
> On 2020/7/8 20:11, Willem de Bruijn wrote:
> > On Tue, Jul 7, 2020 at 11:50 PM Huazhong Tan <tanhuazhong@huawei.com> wrote:
> >>
> >> Add NETIF_F_SOFTWARE_GSO to the the list of GSO features with
> >> a software fallback.  This allows UDP GSO to be used even if
> >> the hardware does not support it,
> >
> > That is already the case if just calling UDP_SEGMENT.
> >
> > It seems the specific goal here is to postpone segmentation when
> > going through a vxlan device?
> >
>
> yes. without this patch, the segmentation is handled before calling
> virtual device's .ndo_start_xmit.
> Like TSO, UDP GSO also should be handle as later as possible?

Sure, but the commit message makes it sounds as if UDP GSO cannot be
used if hardware does not support it right now.
