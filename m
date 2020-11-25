Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 808102C4B01
	for <lists+netdev@lfdr.de>; Wed, 25 Nov 2020 23:45:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733120AbgKYWop (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Nov 2020 17:44:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727365AbgKYWol (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Nov 2020 17:44:41 -0500
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CDD7C0617A7;
        Wed, 25 Nov 2020 14:44:40 -0800 (PST)
Received: by mail-wm1-x342.google.com with SMTP id h21so247913wmb.2;
        Wed, 25 Nov 2020 14:44:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=mMrMdknFbsC77SFRvwwD3pm1cwl3V2MP65kzVJE6tY4=;
        b=mE3/9/w1S1BsFafykdzrNl6nUKLQtv3irXzEz/AwtJdLppuZQnzVWeoYFC7Qb5OQef
         2DAcZ7D6Froq/rlKPIBwqGtt0C/0XmhDJf/Ua0btTGl1wBl77rh04suLM7Drqc/fd1vb
         erjCUGXrwTRfKAEK60/5plkWP59Lm5M7QZ9ENMraFyUEU5TYdKtuuKGBjQ65xtLyj0UE
         nayIBzzwS8QdOAkDbWxTvDHZJGPoguOAiztDitejPSo1Rp931ceTN4KgHMls79AEVEp8
         0UjkiGW0It0CwNfB/koaXcS1sEgjLFm2K1jcT9QDdZUmcgiCMPoll+6KvJ2hAfFlaA1V
         8PSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=mMrMdknFbsC77SFRvwwD3pm1cwl3V2MP65kzVJE6tY4=;
        b=R38/AmTlsvIM12T7AyYl9h5ED9p/mJot6malZaFBOIhS1UbeLy13OmOyiz1xgjm04T
         /HydEJD7nW6ZSDAP65iNZ4ZyQpQlKfNvvG8Zrwvv8uLZSOWvDS2YWdYP5VxYEjwyVAE8
         YSM+eHBamHifsktd0Jjq0qynS/ayYPbhL9PwSiXdby3yGWsiEU1fpts0VkT3C/7OPWXj
         ocRKFhPpzn6ePa6qPzRQhHBuDfNd4agXbMDyMhpJ4ap7fdFyO0BWuBv8VWH5RgyxCUwY
         6Y0qWuDQb3TIvXwQT3pLdiSqYvZXlMRLdWDiZDbV/WByUr20I1nWQ2LPTZlO1wjSr71m
         2AEQ==
X-Gm-Message-State: AOAM532eKSvBjVG+OsfR5iiFXRN7Ljtttg7gTeLIoTGmff0y9VxAQec7
        jDz3jNowF+BUGdrP0/LKn/s=
X-Google-Smtp-Source: ABdhPJzVXPr1uOlB1vaw2cfl6zSoOiLq1F6oo5r6Yg/UanqxqpZONWe00UKvdrBaRFZ4o0pgYT/ByA==
X-Received: by 2002:a7b:cf0a:: with SMTP id l10mr6364382wmg.103.1606344279394;
        Wed, 25 Nov 2020 14:44:39 -0800 (PST)
Received: from [192.168.1.122] (cpc92720-cmbg20-2-0-cust364.5-4.cable.virginm.net. [82.21.83.109])
        by smtp.gmail.com with ESMTPSA id h15sm6411655wrw.15.2020.11.25.14.44.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 Nov 2020 14:44:38 -0800 (PST)
Subject: Re: [PATCH 000/141] Fix fall-through warnings for Clang
To:     Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>,
        James Bottomley <James.Bottomley@hansenpartnership.com>
Cc:     Kees Cook <keescook@chromium.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        alsa-devel@alsa-project.org, amd-gfx@lists.freedesktop.org,
        bridge@lists.linux-foundation.org, ceph-devel@vger.kernel.org,
        cluster-devel@redhat.com, coreteam@netfilter.org,
        devel@driverdev.osuosl.org, dm-devel@redhat.com,
        drbd-dev@lists.linbit.com, dri-devel@lists.freedesktop.org,
        GR-everest-linux-l2@marvell.com, GR-Linux-NIC-Dev@marvell.com,
        intel-gfx@lists.freedesktop.org, intel-wired-lan@lists.osuosl.org,
        keyrings@vger.kernel.org, linux1394-devel@lists.sourceforge.net,
        linux-acpi@vger.kernel.org, linux-afs@lists.infradead.org,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        linux-arm-msm@vger.kernel.org,
        linux-atm-general@lists.sourceforge.net,
        linux-block@vger.kernel.org, linux-can@vger.kernel.org,
        linux-cifs@vger.kernel.org,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        linux-decnet-user@lists.sourceforge.net,
        Ext4 Developers List <linux-ext4@vger.kernel.org>,
        linux-fbdev@vger.kernel.org, linux-geode@lists.infradead.org,
        linux-gpio@vger.kernel.org, linux-hams@vger.kernel.org,
        linux-hwmon@vger.kernel.org, linux-i3c@lists.infradead.org,
        linux-ide@vger.kernel.org, linux-iio@vger.kernel.org,
        linux-input <linux-input@vger.kernel.org>,
        linux-integrity@vger.kernel.org,
        linux-mediatek@lists.infradead.org,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        linux-mmc@vger.kernel.org, Linux-MM <linux-mm@kvack.org>,
        linux-mtd@lists.infradead.org, linux-nfs@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-sctp@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-usb@vger.kernel.org, linux-watchdog@vger.kernel.org,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        netfilter-devel@vger.kernel.org, nouveau@lists.freedesktop.org,
        op-tee@lists.trustedfirmware.org, oss-drivers@netronome.com,
        patches@opensource.cirrus.com, rds-devel@oss.oracle.com,
        reiserfs-devel@vger.kernel.org, samba-technical@lists.samba.org,
        selinux@vger.kernel.org, target-devel@vger.kernel.org,
        tipc-discussion@lists.sourceforge.net,
        usb-storage@lists.one-eyed-alien.net,
        virtualization@lists.linux-foundation.org,
        wcn36xx@lists.infradead.org,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        xen-devel@lists.xenproject.org, linux-hardening@vger.kernel.org,
        Nick Desaulniers <ndesaulniers@google.com>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Miguel Ojeda <ojeda@kernel.org>, Joe Perches <joe@perches.com>
References: <cover.1605896059.git.gustavoars@kernel.org>
 <20201120105344.4345c14e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <202011201129.B13FDB3C@keescook>
 <20201120115142.292999b2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <202011220816.8B6591A@keescook>
 <9b57fd4914b46f38d54087d75e072d6e947cb56d.camel@HansenPartnership.com>
 <CANiq72nZrHWTA4_Msg6MP9snTyenC6-eGfD27CyfNSu7QoVZbw@mail.gmail.com>
 <1c7d7fde126bc0acf825766de64bf2f9b888f216.camel@HansenPartnership.com>
 <CANiq72m22Jb5_+62NnwX8xds2iUdWDMAqD8PZw9cuxdHd95W0A@mail.gmail.com>
 <fc45750b6d0277c401015b7aa11e16cd15f32ab2.camel@HansenPartnership.com>
 <CANiq72k5tpDoDPmJ0ZWc1DGqm+81Gi-uEENAtvEs9v3SZcx6_Q@mail.gmail.com>
 <4993259d01a0064f8bb22770503490f9252f3659.camel@HansenPartnership.com>
 <CANiq72kqO=bYMJnFS2uYRpgWATJ=uXxZuNUsTXT+3aLtrpnzvQ@mail.gmail.com>
From:   Edward Cree <ecree.xilinx@gmail.com>
Message-ID: <44005bde-f6d4-5eaa-39b8-1a5efeedb2d3@gmail.com>
Date:   Wed, 25 Nov 2020 22:44:35 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <CANiq72kqO=bYMJnFS2uYRpgWATJ=uXxZuNUsTXT+3aLtrpnzvQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 25/11/2020 00:32, Miguel Ojeda wrote:
> I have said *authoring* lines of *this* kind takes a minute per line.
> Specifically: lines fixing the fallthrough warning mechanically and
> repeatedly where the compiler tells you to, and doing so full-time for
> a month.
<snip>
> It is useful since it makes intent clear.
To make the intent clear, you have to first be certain that you
 understand the intent; otherwise by adding either a break or a
 fallthrough to suppress the warning you are just destroying the
 information that "the intent of this code is unknown".
Figuring out the intent of a piece of unfamiliar code takes more
 than 1 minute; just because
    case foo:
        thing;
    case bar:
        break;
 produces identical code to
    case foo:
        thing;
        break;
    case bar:
        break;
 doesn't mean that *either* is correct — maybe the author meant
 to write
    case foo:
        return thing;
    case bar:
        break;
 and by inserting that break you've destroyed the marker that
 would direct someone who knew what the code was about to look
 at that point in the code and spot the problem.
Thus, you *always* have to look at more than just the immediate
 mechanical context of the code, to make a proper judgement that
 yes, this was the intent.  If you think that that sort of thing
 can be done in an *average* time of one minute, then I hope you
 stay away from code I'm responsible for!
One minute would be an optimistic target for code that, as the
 maintainer, one is already somewhat familiar with.  For code
 that you're seeing for the first time, as is usually the case
 with the people doing these mechanical fix-a-warning patches,
 it's completely unrealistic.

A warning is only useful because it makes you *think* about the
 code.  If you suppress the warning without doing that thinking,
 then you made the warning useless; and if the warning made you
 think about code that didn't *need* it, then the warning was
 useless from the start.

So make your mind up: does Clang's stricter -Wimplicit-fallthrough
 flag up code that needs thought (in which case the fixes take
 effort both to author and to review) or does it flag up code
 that can be mindlessly "fixed" (in which case the warning is
 worthless)?  Proponents in this thread seem to be trying to
 have it both ways.

-ed
