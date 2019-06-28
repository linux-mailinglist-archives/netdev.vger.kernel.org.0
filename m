Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B4EEB5A5E2
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 22:29:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727180AbfF1U3F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 16:29:05 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:41724 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727042AbfF1U3E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jun 2019 16:29:04 -0400
Received: by mail-pl1-f196.google.com with SMTP id m7so3844757pls.8;
        Fri, 28 Jun 2019 13:29:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=bnEv+X6GYtFiiNujnuspHfQ9vua0ZpFbOcCMm5XfbHM=;
        b=l+e/PGzpskxEFOlTnLnrRwwaulooIqK74WgIkScA6HRkwzfRCZ/7B1LKz5weRN4t/M
         /YBioajcNC6WBbc8aulGwaVlaXzC48XHY3DoZ6FnoXctvndgSG8M3CY8m0Wdfs5PrMj+
         wW5ZI+TVtOFxOmIEQayasbUFZUKDs+kYVwdaSY0eaSqv33hxy55JJzZO2v6z8Vfxclhy
         usVo0Vtziyr4Y8oBufCzP7UpTj3mRnZBywhSYLP04QDr+ilYa4F9WzahhgX9HnUSXW5b
         yGW68vIJqYpA/RLFrsvVWjkxizf/zFH2gBMXppKaDwstfC6UYSXnYzFZE43P7wzpl/k8
         7N7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bnEv+X6GYtFiiNujnuspHfQ9vua0ZpFbOcCMm5XfbHM=;
        b=mJSPfBp534AbUzaTbTKRe6xcKXEFU+uIxlhQ67aA6FF7kQ/0OuLhcsKB+fyWE/8+t3
         I6GmhWuV/UlvW9cRLs+Y6Ce/kjLiE29PTN64AVds3FnttvpP7+dmkte4SRSeyeH5KjYL
         C+nI2RGAVJoRgO9uP3txfl6Zv5sl1zS3KyT4aEdQNZPWi5u4RRN1GlYFSF53BSMCjEr0
         cSMofM1D0m5qYShcSnlhjqU7RUiYVsXLO5MjRaex4rXdL4LywuXSjxLCgoxwycW/lm2a
         VOztCzSR5zvF3mNSjgtBW9vd+Uq3+GyNiZyLsSJTK3VRNQeNSHl5m3w5B2jzWKfd7SCQ
         hKTA==
X-Gm-Message-State: APjAAAWXqR4+Jed5+BvExJJUNoYZGTx3MkDR8PPBzTqZ1lD4XexKnSIq
        SDE9JAhWau+XQ7i+9gOJkyc=
X-Google-Smtp-Source: APXvYqzWa8U43FknwvBkH/7zwA5fqURcefu1/ahKJcv8NB+c8DMHbs/Cdwiqmx9Ug400ur6gkg0Qcw==
X-Received: by 2002:a17:902:8a8a:: with SMTP id p10mr14126514plo.88.1561753744049;
        Fri, 28 Jun 2019 13:29:04 -0700 (PDT)
Received: from [172.20.54.151] ([2620:10d:c090:200::e695])
        by smtp.gmail.com with ESMTPSA id r15sm4509802pfc.162.2019.06.28.13.29.03
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 28 Jun 2019 13:29:03 -0700 (PDT)
From:   "Jonathan Lemon" <jonathan.lemon@gmail.com>
To:     "Laatz, Kevin" <kevin.laatz@intel.com>
Cc:     "Jakub Kicinski" <jakub.kicinski@netronome.com>,
        netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        bjorn.topel@intel.com, magnus.karlsson@intel.com,
        bpf@vger.kernel.org, intel-wired-lan@lists.osuosl.org,
        bruce.richardson@intel.com, ciara.loftus@intel.com
Subject: Re: [PATCH 00/11] XDP unaligned chunk placement support
Date:   Fri, 28 Jun 2019 13:29:02 -0700
X-Mailer: MailMate (1.12.5r5635)
Message-ID: <BAE24CBF-416D-4665-B2C9-CE1F5EAE28FF@gmail.com>
In-Reply-To: <f0ca817a-02b4-df22-d01b-7bc07171a4dc@intel.com>
References: <20190620083924.1996-1-kevin.laatz@intel.com>
 <FA8389B9-F89C-4BFF-95EE-56F702BBCC6D@gmail.com>
 <ef7e9469-e7be-647b-8bb1-da29bc01fa2e@intel.com>
 <20190627142534.4f4b8995@cakuba.netronome.com>
 <f0ca817a-02b4-df22-d01b-7bc07171a4dc@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed; markup=markdown
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 28 Jun 2019, at 9:19, Laatz, Kevin wrote:

> On 27/06/2019 22:25, Jakub Kicinski wrote:
>> On Thu, 27 Jun 2019 12:14:50 +0100, Laatz, Kevin wrote:
>>> On the application side (xdpsock), we don't have to worry about the 
>>> user
>>> defined headroom, since it is 0, so we only need to account for the
>>> XDP_PACKET_HEADROOM when computing the original address (in the 
>>> default
>>> scenario).
>> That assumes specific layout for the data inside the buffer.  Some 
>> NICs
>> will prepend information like timestamp to the packet, meaning the
>> packet would start at offset XDP_PACKET_HEADROOM + metadata len..
>
> Yes, if NICs prepend extra data to the packet that would be a problem 
> for
> using this feature in isolation. However, if we also add in support 
> for in-order
> RX and TX rings, that would no longer be an issue. However, even for 
> NICs
> which do prepend data, this patchset should not break anything that is 
> currently
> working.

I read this as "the correct buffer address is recovered from the shadow 
ring".
I'm not sure I'm comfortable with that, and I'm also not sold on 
in-order completion
for the RX/TX rings.



>> I think that's very limiting.  What is the challenge in providing
>> aligned addresses, exactly?
> The challenges are two-fold:
> 1) it prevents using arbitrary buffer sizes, which will be an issue 
> supporting e.g. jumbo frames in future.
> 2) higher level user-space frameworks which may want to use AF_XDP, 
> such as DPDK, do not currently support having buffers with 'fixed' 
> alignment.
>     The reason that DPDK uses arbitrary placement is that:
>         - it would stop things working on certain NICs which 
> need the actual writable space specified in units of 1k - therefore we 
> need 2k + metadata space.
>         - we place padding between buffers to avoid constantly 
> hitting the same memory channels when accessing memory.
>         - it allows the application to choose the actual buffer 
> size it wants to use.
>     We make use of the above to allow us to speed up processing 
> significantly and also reduce the packet buffer memory size.
>
>     Not having arbitrary buffer alignment also means an AF_XDP 
> driver for DPDK cannot be a drop-in replacement for existing drivers 
> in those frameworks. Even with a new capability to allow an arbitrary 
> buffer alignment, existing apps will need to be modified to use that 
> new capability.

Since all buffers in the umem are the same chunk size, the original 
buffer
address can be recalculated with some multiply/shift math.  However, 
this is
more expensive than just a mask operation.
-- 
Jonathan
