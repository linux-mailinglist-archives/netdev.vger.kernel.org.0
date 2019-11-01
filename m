Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 664DDEC971
	for <lists+netdev@lfdr.de>; Fri,  1 Nov 2019 21:15:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727754AbfKAUPC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Nov 2019 16:15:02 -0400
Received: from mout.web.de ([212.227.17.12]:54799 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726477AbfKAUPB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 1 Nov 2019 16:15:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1572639283;
        bh=KWbCttR85rCyn/zrFxTySFggytEnyAXRs/QVJBQgKmA=;
        h=X-UI-Sender-Class:To:Cc:References:Subject:From:Date:In-Reply-To;
        b=VHkrXC1sUFvXWPxeysveWPbxaomccrDis/BFA/Vt6qMAra5G/U0Q+IlnrDCyQewZL
         ip6aGwYdwug1muC8HoatAkDUFz0pZfy5DI+QvYzfRIPdDzWmJsmQuOPCXYe4jDwYdv
         401cTWcJPKY3QAZ+61QjHH9PfsNL/MoZF/sN9WOc=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [192.168.1.2] ([93.131.35.66]) by smtp.web.de (mrweb102
 [213.165.67.124]) with ESMTPSA (Nemesis) id 0MSads-1iYRM71G8y-00RVKh; Fri, 01
 Nov 2019 21:14:43 +0100
To:     Haiyang Zhang <haiyangz@microsoft.com>,
        linux-hyperv@vger.kernel.org, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Olaf Hering <olaf@aepfle.de>, Sasha Levin <sashal@kernel.org>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
References: <1572449471-5219-3-git-send-email-haiyangz@microsoft.com>
Subject: Re: [PATCH net, 2/2] hv_netvsc: Fix error handling in netvsc_attach()
From:   Markus Elfring <Markus.Elfring@web.de>
Autocrypt: addr=Markus.Elfring@web.de; prefer-encrypt=mutual; keydata=
 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 FEE=
Message-ID: <77a1611b-1609-ca74-39d0-3ecd16290219@web.de>
Date:   Fri, 1 Nov 2019 21:14:33 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <1572449471-5219-3-git-send-email-haiyangz@microsoft.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:SCcExs1y5Q1jY9WmuuvG3B+2WCBC6Tr4Bcdk3s7BBEyvLqRdnKv
 iER20hZ0gNEcjlClFJ30QkoPSKWR+7b5jN1jeo8CeejVYVVFHiJY2qTFLSVAyQGeXK/auZm
 I28o3W8SFSOQE7F5k3bq4E3Cn4MveWOEnEMfrsY5CqxclxEfsWDpJbowfzlSDSnwbtHOzhN
 C3VT5sdlHZkdJiXc8J4Eg==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:akzISLPxtSI=:o2OUpBxYQpwOoukfWPxzDt
 iD0wQyaDjp40jnE8GcPJa3NzEfF/tfRr+Si/7dHXXHaiIF+REuiNP+Dbvn3dh3lCiJZFkBcmh
 8uFov+YiKh45Ba6XHIvevwSPy8Ie+ssqSMiceA7FDBrVm2Q4DPq/UGJC98zUSmHCOLooL6ePS
 e5o493z4NIbEUeW29gUWOji9kHZ7gVFfL4Jq9o3bWSQglBwGaTsAW/xyYYkMEleMiGbbp5tnK
 tab7g/1qeuqoghbVBezNg2icEfEarhblyq8lOnaKqdo8rYf9npYL/qpPEXuk9262gf708bWbX
 NgzK5c6BRFDt1ihQy3yg29Mwj49+iAKRQtwhXWs9RXLgarV6EuQ4rFV0ixpgsYAOk1MOYmaEe
 pMgXt51yKlxjfqFH4hk0v7x4FJfIke1oC50EPraSknE4q6obi5hSqXXW2NQXp2UrG/A6Sc7P7
 /OCpv5R2fFmf8tWqkDPWudfDcp4w0ygIGQ/V/rOvR08O8eRjg/dxaBwbKyz05G5jdw82NTYbO
 vlw0SccqMRDF6esWtw70F013SuXa0LXvUF8Tg9JAr2Y3xAxqm0Vv30FY03bIazuKCuhHSWxvK
 8WodFuxxJ4jNjy/t6dljB0DiAHmkms+lGF7dtSjrf+opzQayFq4p0nIlFSg2IY1WuoECdXvMe
 uFlhBZsR/S2tskLzH/Uscltu2OMAh+DNos+vdUor+YOddAWg4kw+bXOR0R7CPTdVtGIrOFFOl
 esMRX9C+tHh1cguPTl5a0v37Yv4KxVjYxFRkpMfeG26d/rba0O/OpWfxRcdcJ/yNE+pba6v8Q
 918p65xBMG+YOUkfZ0cBJ48bExxmgTaqlsHTcOcf331rfFfb2DR0rE4UjaQdS1FqYihATSaYG
 uNM7xKfCnatGFme4NbnORQmCKLfPJLdfIsE2oOXaYWFvZw70qkXYw0Bh/6eUjsEtYSLsgjTmB
 MQ6vHRqd/njBI/jomXCxFPF/o3LryqKjnbWSQBNAmBgQ6+Au2O5tconTZetCmzWms/NphMsjR
 xAQAkxf+NSGiGceqw5xqtJyx9UctNj4yDsIm4VzZNug5PWFG9jfm9aGmS+EHBlN37o9VX+l3O
 K4n7yFYNI9WiJO3yHbqkOVNYlisDjX/b62x0iu/DVBk/b2gtJmKqHcZ67PD4V970e9SF6RC7A
 y79EV5jpBe62r3iBwAadPnbJbuCdkMDZp3qrotTrw8WXEg1WOR5GonIzm/tIJHSYycNG8DiI5
 t3dfwJJOMRppSzhdWxNwyGbjbOwSxn8r/3qv2z8uZ4dneKa0ULkuKTgodX0c=
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

=E2=80=A6
> +++ b/drivers/net/hyperv/netvsc_drv.c
> @@ -982,7 +982,7 @@ static int netvsc_attach(struct net_device *ndev,
>  	if (netif_running(ndev)) {
>  		ret =3D rndis_filter_open(nvdev);
>  		if (ret)
> -			return ret;
> +			goto err;
>
>  		rdev =3D nvdev->extension;
>  		if (!rdev->link_state)
=E2=80=A6

I would prefer to specify the completed exception handling
(addition of two function calls) by a compound statement in
the shown if branch directly.

If you would insist to use a goto statement, I find an other label
more appropriate according to the Linux coding style.

Regards,
Markus
