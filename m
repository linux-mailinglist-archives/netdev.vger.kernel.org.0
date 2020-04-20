Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCF2D1B1067
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 17:42:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728628AbgDTPmZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 11:42:25 -0400
Received: from mout.web.de ([212.227.15.4]:41347 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726756AbgDTPmX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Apr 2020 11:42:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1587397331;
        bh=+6ogmdR4TKJRspsZ0dYsuYS9QeYNt+KPEkX24l0p8Co=;
        h=X-UI-Sender-Class:Subject:To:Cc:References:From:Date:In-Reply-To;
        b=KPRurKLPMuvWh2tL30CvnDva0snRe6g0nKO0N3GbCWRy7im3yFHdc7fAdfttZ/yqC
         QsDcjwgjwCCr8XA9HlfqCLk57ZuP+pQJIrqn9+tDBL5hcYo1C2a/SvMh5Kwucq4VdB
         Tt4BgehCGRkuhthcGrsokpBpAU6F8zva2iVpVVtY=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [192.168.1.2] ([2.244.153.203]) by smtp.web.de (mrweb003
 [213.165.67.108]) with ESMTPSA (Nemesis) id 0MFt3u-1jUSZx2ihi-00Es9W; Mon, 20
 Apr 2020 17:42:11 +0200
Subject: Re: [net-next v2] can: ti_hecc: convert to
 devm_platform_ioremap_resource_byname()
To:     Dejin Zheng <zhengdejin5@gmail.com>, netdev@vger.kernel.org
Cc:     linux-can@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Wolfgang Grandegger <wg@grandegger.com>
References: <20200420132207.8536-1-zhengdejin5@gmail.com>
 <940fcaa1-8500-e534-2380-39419f1ac5a0@web.de> <20200420141921.GA10880@nuc8i5>
 <3fd53b73-87b3-b788-d984-cb1c719f9e7f@web.de> <20200420151911.GA2698@nuc8i5>
From:   Markus Elfring <Markus.Elfring@web.de>
Autocrypt: addr=Markus.Elfring@web.de; prefer-encrypt=mutual; keydata=
 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 FEE=
Message-ID: <a6fbdb0b-60be-baae-ad17-1977ed12fdaa@web.de>
Date:   Mon, 20 Apr 2020 17:42:04 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200420151911.GA2698@nuc8i5>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
X-Provags-ID: V03:K1:leJQCm12TYzK5GP8K2GRWdEXDXEvixRBbbT65zSEL+9i3eWKJW/
 HmI+CXEh87zWBgw1eu0HxaX4bDvmbNHRfWdrBXbqxV1JMn7nuMKqS0lwoLUbo2Ce8jD9Sz8
 uLMytPiLutEjpbaupn7VQQkoimpJJVmyJy9wefhsZ9TEOT4xL+ZX34i1Ca5IRgV6TsHIhVu
 nNaPN9uyoUjZjg7ECRtag==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:UZEUpkiVbBU=:Cq5WZIn2UVBpRtULrOrJ6T
 dDye6Mv/WttrCf7ZrG88PkJNyM+XYYCywv+iNsknhLDZncj7Riilxoa7BV+l9a8KmRtHK+SpI
 aLp25rIN/iQHcGmTNXulCldW2lugYSL5Tbv9U4fR+UBEV7zTAsyKu3SEZhLM4KjMbCDcOCpDy
 7us6fr/FAoEWS33wNXCy9HphG3KEBhpUSyq0pR9xsdf19yCL1pCzmccXrYX+Ul5JtJvtJlux2
 42HDdZSeCCprTVtfQCfObzP7AM+p9GE2os54utZdD7qAGNkMlF31PfMGg6HbKyrI0VJqml8h5
 fu+EAxjqmhO3S7xfS/nUILd2gHEoHp/nwLjeOlwUkmQHKolpkP0bWFBuHdG94fgNbeKsDpnDX
 FVqWbLgZy0dWz+ZJ4O3oixwf62F0kMpheLS06wPwKMFv/+dyV521ydIKWG5uG5GuhZDsNRdRJ
 ylOQTRJxjyYlGcYHQu1ldCAuvE8HbcpyCeAKiPyc9v+m8UjvkM3GI330V2elaWpwlkz/hKd4Z
 1+2WyQlT/o9t+jBDqeG/Tysm8Kd9R2TNTDTenqM/jlqwH79gPWhIZ0VPTUq6ZX6lWVjHLLDAD
 fkve/D4Wwv5aPQiXC9w7uPCPIJgL+YSEDaCGKO5XXr1NuMD7+SHRllNwn+n2eZTAuGw0VGZoS
 3yZUknVXEy3YBJ6Ufg3HfQCRXE/+ar74iyK1rJRiJUe0sRR6eR8eg/odrNQAgW/0cNyXC3MK1
 Qk+gR2p3hKTXyWc37P6Sj2njyeHCc5VptLqspoCAKMTp/HOtzrK2+35n3C+FrptnZ+Gx9uciq
 L/9UOo5HzkX3P9Gfo7i3nA6BRqwcsSE/U58l5qvIUP8BmHG0Ssz7la1vxjnJpN6CZMEutH5mR
 e5DFw9dAzf1fKPuPRx+GnEA2kJ2zJSHEAoVUypMFQ33tRjNkfM7LGZorY64MtUoOwhBIplPvZ
 i5uFTdXQRVni8mTrpp0F1Vmsyy++klw5EWpNKgkPMtDMtqFkTRe9gEyrf2f4BCrI+4McpyPh8
 BqGAX0wn9ZyTf9QGZZG1OHWMdc5qoa0kL6FGUNV+4h2tRXyqTxdEJ7YGD2wrPx3qGLfvdAGAR
 3k0/ianh2OunKQJSCUYWDHnch/rUBEla7GdCB5tjjzk+WwDCTnfqsets9nHfV79j331ZdqazT
 AQEHqCzpfsiVArVPKMAR6v98FZsccgeCOyQj8zv0IFRTKcRJnni2gczzda5PEjBbsqG0PwK8f
 vrNs1O1xy/0LQyAsD
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>> If you would use another script (like for the semantic patch language),
>> you could find remaining update candidates in a convenient way,
>> couldn't you?
>>
> Markus, could you share the script?

Theoretically, yes.

Practically, I would prefer additional development options.

* I am trying for a while to improve some components also by advanced
  applications of the Coccinelle software.
  I hope to increase incentives for involved contributors.

* I imagine that a known directory would be a nice place for
  further reuse of such SmPL scripts.
  https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/scripts/coccinelle?id=ae83d0b416db002fe95601e7f97f64b59514d936

* How will your motivation evolve?
  + Pick more updates for your own contribution statistics.
  And / Or
  + Tell more interested parties about change possibilities.

Regards,
Markus
