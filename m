Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D29B130459
	for <lists+netdev@lfdr.de>; Thu, 30 May 2019 23:57:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726855AbfE3V5S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 May 2019 17:57:18 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:35193 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726836AbfE3V5R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 May 2019 17:57:17 -0400
Received: by mail-pg1-f194.google.com with SMTP id t1so2787114pgc.2
        for <netdev@vger.kernel.org>; Thu, 30 May 2019 14:57:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=jwOSziE1g6AU7/BuCW88qP0z6DOdF+tBLJid5htJoJU=;
        b=BZOSUFsVCUlejFacyO7dckanzc4FRhj9XLumuDKVjkSl15JywsbmdqjbwerxnWorHZ
         TCtUox7gELVyKvglBF7puZBKrVzpiB6S9GaJ6ip0ZlUah0FEz5RBdCpoyvex/9FHIPLs
         0TSfPJy4fHTkBwE5j0jZiiq0fBWR5SK5glkl4AyN0Vtm7nzk7Un/lcW24Jx+nUxHCg+p
         mzS9O4W633SLCMGUWbC7yED0RsXvkwJ/AfWOtqIcfDfn/qPJeoM0ivBFmTmY+kouj5Os
         Dy8mTTxMqijldu8q+1fXs3DSfJIy6gkCFsJcre54yINL6Zn61dgw5Nwy0fyH2kxocNf9
         aK6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=jwOSziE1g6AU7/BuCW88qP0z6DOdF+tBLJid5htJoJU=;
        b=Ef9auqUvCy75w4r9GkXWwTOB2sOyLCrdsDJ+q5hCntH8KrD/Ldczi+jlwmY+RfaLl2
         h6kZIFQLlMvTkp9Ya2OTv1QayT00Igyp7at2S+cxCz/mN9ySIVzBeFVLJlMubB+SIs96
         a/WwpJQPMs2LWm/2JFD5DC2dScFJOt4Y9nzTHNTRO+QBBRsRz0ONB4b/KyEET/VSyLei
         GasDSmUBCfA9nY7ag9sDuWIlkJ6b8XeyKS8nPahMN4HSPGQHaK+g/7Q5z8ynU9t6w+dq
         NTiDed0VjIf14nkq5LeQljWBQlm8izZbz0VNcW1e6MhyoVNx4WJ4LBPytYU6R2Yzbzuy
         alow==
X-Gm-Message-State: APjAAAWYbjtkxG1xDVXDRmpM6o39fv2Co80C6AXyZkRuuMNg+sYIXQMF
        NjHUR1fgm6FZe39odt+80JfVQsIT0yo=
X-Google-Smtp-Source: APXvYqz4krn32cAtH8AhNR38q5ZxbvJkF4/y0my9QdDBqv1rN389GH1SvytElpeMY5iEEkPJX7iDTQ==
X-Received: by 2002:a17:90a:9385:: with SMTP id q5mr5323301pjo.126.1559253012454;
        Thu, 30 May 2019 14:50:12 -0700 (PDT)
Received: from [172.27.227.250] ([216.129.126.118])
        by smtp.googlemail.com with ESMTPSA id b90sm4564269pjc.0.2019.05.30.14.50.10
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 30 May 2019 14:50:11 -0700 (PDT)
Subject: Re: [PATCH net-next] vrf: local route leaking
To:     George Wilkie <gwilkie@vyatta.att-mail.com>
Cc:     Shrijeet Mukherjee <shrijeet@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        netdev@vger.kernel.org
References: <20190524080551.754-1-gwilkie@vyatta.att-mail.com>
 <0d920356-8d12-b0b5-c14b-3600e54e9390@gmail.com>
 <20190525070924.GA1184@debian10.local>
 <47e25c7c-1dd4-25ee-1d7b-f8c4c0783573@gmail.com>
 <20190527083402.GA7269@gwilkie-Precision-7520>
 <1f761acd-80eb-0e80-1cf4-181f8b327bd5@gmail.com>
 <20190530205250.GA7379@gwilkie-Precision-7520>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <f0f4b5c8-0beb-6c97-34c8-f5b73ea426b8@gmail.com>
Date:   Thu, 30 May 2019 15:50:09 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20190530205250.GA7379@gwilkie-Precision-7520>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/30/19 2:52 PM, George Wilkie wrote:
> This doesn't work for me (again, not using namespaces).
> For traffic coming in on vrf-b to a destination on 10.200.2.0,
> I see ARPs going out for the destination on xvrf2/in on xvrf1,
> but nothing replies to it.

Is rp_filter set?
