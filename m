Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D06B2B1356
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 01:39:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726101AbgKMAjG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 19:39:06 -0500
Received: from smtp.uniroma2.it ([160.80.6.22]:41230 "EHLO smtp.uniroma2.it"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725894AbgKMAjF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Nov 2020 19:39:05 -0500
Received: from smtpauth-2019-1.uniroma2.it (smtpauth.uniroma2.it [160.80.5.46])
        by smtp-2015.uniroma2.it (8.14.4/8.14.4/Debian-8) with ESMTP id 0AD0bv1k018087;
        Fri, 13 Nov 2020 01:38:02 +0100
Received: from lubuntu-18.04 (unknown [160.80.103.126])
        by smtpauth-2019-1.uniroma2.it (Postfix) with ESMTPSA id 1A1A6120069;
        Fri, 13 Nov 2020 01:37:53 +0100 (CET)
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=uniroma2.it;
        s=ed201904; t=1605227873; h=from:from:sender:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QzDzmHyR3r8nJNjVFHhg+KVpKPhmjuMkbEJ5Uc+BknM=;
        b=LtEykvNrghbg+WiFuD5gb2B0Ymac3bJ/Fw/4N7gnoVGUqakfB9+wfAXRa+hhLKVbLAW2h7
        7Cs438xeXz9AMKDQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniroma2.it; s=rsa201904;
        t=1605227873; h=from:from:sender:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QzDzmHyR3r8nJNjVFHhg+KVpKPhmjuMkbEJ5Uc+BknM=;
        b=n2bNAP0uooWj5XZeLFTYiWNqg8KtlgKgs5elSdeQ2qXkVBQ2CCpbIMqlaLXgp9TfBfeULN
        gU/tE5NWyE9Vqis8kryifu2fYXO6Liqz+iPk9s23mup8/xevFtdIaAcZpntGvCpzUvWXYb
        a8vGD97iuCO+5zu13uVQ5l0MQji5/C14tp4tcehOSCEbnZPMRZUl8lLxadYuB8BDXVxmCY
        z2V4/VfIZ7hwIAfntsWhSb/B8xh145V2MV07iMlsK2cCcMER5eSKX9GF0QnqcyksvwANDn
        ImaQ7eaCkABKV/FGkl+cc/D9m4o62D011dExVWe1H956dxKxH/rnfLk9fQ4JzQ==
Date:   Fri, 13 Nov 2020 01:37:52 +0100
From:   Andrea Mayer <andrea.mayer@uniroma2.it>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        David Ahern <dsahern@kernel.org>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Shuah Khan <shuah@kernel.org>,
        Shrijeet Mukherjee <shrijeet@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        Stefano Salsano <stefano.salsano@uniroma2.it>,
        Paolo Lungaroni <paolo.lungaroni@cnit.it>,
        Ahmed Abdelsalam <ahabdels.dev@gmail.com>,
        Andrea Mayer <andrea.mayer@uniroma2.it>
Subject: Re: [net-next,v2,1/5] vrf: add mac header for tunneled packets when
 sniffer is attached
Message-Id: <20201113013752.ea050bf062d45744500d42d8@uniroma2.it>
In-Reply-To: <20201110145045.22dfd58e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20201107153139.3552-1-andrea.mayer@uniroma2.it>
        <20201107153139.3552-2-andrea.mayer@uniroma2.it>
        <20201110145045.22dfd58e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Virus-Scanned: clamav-milter 0.100.0 at smtp-2015
X-Virus-Status: Clean
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,

On Tue, 10 Nov 2020 14:50:45 -0800
Jakub Kicinski <kuba@kernel.org> wrote:

> On Sat,  7 Nov 2020 16:31:35 +0100 Andrea Mayer wrote:
> > Before this patch, a sniffer attached to a VRF used as the receiving
> > interface of L3 tunneled packets detects them as malformed packets and
> > it complains about that (i.e.: tcpdump shows bogus packets).
> > 
> > The reason is that a tunneled L3 packet does not carry any L2
> > information and when the VRF is set as the receiving interface of a
> > decapsulated L3 packet, no mac header is currently set or valid.
> > Therefore, the purpose of this patch consists of adding a MAC header to
> > any packet which is directly received on the VRF interface ONLY IF:
> > 
> >  i) a sniffer is attached on the VRF and ii) the mac header is not set.
> > 
> > In this case, the mac address of the VRF is copied in both the
> > destination and the source address of the ethernet header. The protocol
> > type is set either to IPv4 or IPv6, depending on which L3 packet is
> > received.
> > 
> > Signed-off-by: Andrea Mayer <andrea.mayer@uniroma2.it>
> 
> Please keep David's review tag since you haven't changed the code.

I will keep David's review tag in v3.

Thanks,
Andrea
