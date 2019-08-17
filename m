Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 812C8910A9
	for <lists+netdev@lfdr.de>; Sat, 17 Aug 2019 16:02:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726033AbfHQOCK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Aug 2019 10:02:10 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:37532 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725945AbfHQOCJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Aug 2019 10:02:09 -0400
Received: by mail-pg1-f196.google.com with SMTP id d1so3785775pgp.4;
        Sat, 17 Aug 2019 07:02:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Lg/gteB5jcgk4P7pTBTBE8oTq7EjI3gE+e8xvyMR8nY=;
        b=CSXu6cRLDT6ts1zWS6LM+MjDfuedyT7uW2vAtJ9NkPX8Igx4ScuC6QVDsaBpvMJse3
         nfUIhVsGyJKczBepizWDqxh84c+VnhAHGTwZxGzgiAGykxdPTCdhGLr3XJPqZQR+H6F8
         bdLpCGMErUSMksUGmn3HXYfLbiwSj6UXEWeQokt+7qa4WmfyTxD58EiTO6s2AwPwuA4U
         Xw3X2x5D1wOTotJeSWwXV9hZ999smsY1xDu4njqa8MvEPVVfGDYrQ9UwUpUHkyvYCWw2
         1OpxeSyp91UJVzZlcmTKfsILccXCqP3I34HpDtocdgBz0ERFJtCOzvNSE9VhxdgXr6yQ
         /Hlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Lg/gteB5jcgk4P7pTBTBE8oTq7EjI3gE+e8xvyMR8nY=;
        b=i9qakIx+t87Pfu+aCpe0k2Ebr65ybBaaBH9RRgYV0e9BFj4ZkwyXtnoyxm2sScAr48
         dHafRFQ9t3v8ZTa5a9IuTef+s2VYaVY3bbQFbsps9IMGyvf0DRA7XzjhgM63p+fXIoS3
         D/nRPlborAZVdE3S25540D+1wxnQ3pRxFkHPYUySyKgcpBDfVMl8T6GA9puTRQWWX/+2
         G1NbdqOtwl5bA3nHKRi12YaPEsWXOkPs96qKbO3Rj+c0E3ynwVbDDV6G7GLl01N7PRJT
         bzbiryoD/SDQWqYlNALExU6A0l1httQGQQAvARf2i2n4ILoQQni6nJj2x1KGv+dd4Hmu
         adnQ==
X-Gm-Message-State: APjAAAWZfUNevG+TaDMAjuBdbByNI2AeTGy67dg7YwH1G1QcSot4IYla
        Ci0Ob1/IZHDzas36rRHyWMw=
X-Google-Smtp-Source: APXvYqzIHhBy4grTQqm6P2J4CgZBVa+vt+adB+TFRWVf9BAKEGPKdWZndTnvu9MY2rfNuWA8Ljn65w==
X-Received: by 2002:a17:90a:5803:: with SMTP id h3mr176245pji.133.1566050529177;
        Sat, 17 Aug 2019 07:02:09 -0700 (PDT)
Received: from ?IPv6:240d:2:6b22:5500:b8ce:7113:7b93:9494? ([240d:2:6b22:5500:b8ce:7113:7b93:9494])
        by smtp.googlemail.com with ESMTPSA id s16sm6558026pjp.10.2019.08.17.07.02.04
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 17 Aug 2019 07:02:08 -0700 (PDT)
Subject: Re: [RFC PATCH bpf-next 00/14] xdp_flow: Flow offload to XDP
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     Stanislav Fomichev <sdf@fomichev.me>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, William Tu <u9012063@gmail.com>
References: <20190813120558.6151-1-toshiaki.makita1@gmail.com>
 <20190814170715.GJ2820@mini-arch>
 <14c4a876-6f5d-4750-cbe4-19622f64975b@gmail.com>
 <20190815152100.GN2820@mini-arch>
 <20190815122232.4b1fa01c@cakuba.netronome.com>
 <da840b14-ab5b-91f1-df2f-6bdd0ed41173@gmail.com>
 <20190816115224.6aafd4ee@cakuba.netronome.com>
From:   Toshiaki Makita <toshiaki.makita1@gmail.com>
Message-ID: <5e9bee13-a746-f148-00de-feb7cb7b1403@gmail.com>
Date:   Sat, 17 Aug 2019 23:01:59 +0900
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190816115224.6aafd4ee@cakuba.netronome.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 19/08/17 (土) 3:52:24, Jakub Kicinski wrote:
> On Fri, 16 Aug 2019 10:28:10 +0900, Toshiaki Makita wrote:
>> On 2019/08/16 4:22, Jakub Kicinski wrote:
>>> There's a certain allure in bringing the in-kernel BPF translation
>>> infrastructure forward. OTOH from system architecture perspective IMHO
>>> it does seem like a task best handed in user space. bpfilter can replace
>>> iptables completely, here we're looking at an acceleration relatively
>>> loosely coupled with flower.
>>
>> I don't think it's loosely coupled. Emulating TC behavior in userspace
>> is not so easy.
>>
>> Think about recent multi-mask support in flower. Previously userspace could
>> assume there is one mask and hash table for each preference in TC. After the
>> change TC accepts different masks with the same pref. Such a change tends to
>> break userspace emulation. It may ignore masks passed from flow insertion
>> and use the mask remembered when the first flow of the pref is inserted. It
>> may override the mask of all existing flows with the pref. It may fail to
>> insert such flows. Any of them would result in unexpected wrong datapath
>> handling which is critical.
>> I think such an emulation layer needs to be updated in sync with TC.
> 
> Oh, so you're saying that if xdp_flow is merged all patches to
> cls_flower and netfilter which affect flow offload will be required
> to update xdp_flow as well?

Hmm... you are saying that we are allowed to break other in-kernel 
subsystem by some change? Sounds strange...

> That's a question of policy. Technically the implementation in user
> space is equivalent.
 >
> The advantage of user space implementation is that you can add more
> to it and explore use cases which do not fit in the flow offload API,
> but are trivial for BPF. Not to mention the obvious advantage of
> decoupling the upgrade path.

I understand the advantage, but I can't trust such a third-party kernel 
emulation solution for this kind of thing which handles critical data path.

> Personally I'm not happy with the way this patch set messes with the
> flow infrastructure. You should use the indirect callback
> infrastructure instead, and that way you can build the whole thing
> touching none of the flow offload core.

I don't want to mess up the core flow infrastructure either. I'm all 
ears about less invasive ways. Using indirect callback sounds like a 
good idea. Will give it a try. Many thanks.

Toshiaki Makita
