Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7E9F3A3452
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 21:53:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230255AbhFJTzX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 15:55:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229823AbhFJTzW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Jun 2021 15:55:22 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D752C061574;
        Thu, 10 Jun 2021 12:53:13 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id i94so3592083wri.4;
        Thu, 10 Jun 2021 12:53:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=WKZ3KW6u4pbZ+DdnZJ+w+BNWUSdvXfmfuHtBXcnQNug=;
        b=YqZz0iLZvoXEYFhVxD/44Ui/wx5seiLEZ0+suHKu7RivHMZJrufQhwP6VsLJUzZNcy
         fZxqR44V5QkRnkSqa2Ic4gh4QLOgCsLbe9YvoF1tomaXy4Lnwd9TGNhBW9ba7O2g/7vP
         Q4HgrPZl3m4+vVVg+tFe1uCjb9vC4Tmk9rVN4IZyYIOjdcGlXMUG/bgOlqvdRuZdtD1L
         JQfUvkxelH18F3sTyhFXzHEByk3ObZ+kz7hNM/hOs73e6vx8vHQ77MziJVPbjmmcnFEv
         buggFdkbiHyAWtQn6M7MVf5vYhg8AllARAEnqSfIrZtatTAbXB1roVcPEKrO19Wu4oHY
         yp5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=WKZ3KW6u4pbZ+DdnZJ+w+BNWUSdvXfmfuHtBXcnQNug=;
        b=RskyZW6+B8VfjiPAQva+/jqnxqIDvU++6jwuIYf7CN2A1x4CcYIq9Kgwy3BK49hGdm
         DtBPa+vQJpbaDXU+ZzzaqROEsUxsLC5xE9IuOPGWOH29Pbi/fiMC2IllqDwXcmvan5hT
         hmFzm8DgHYXYdKO37gpC/Q75F/DIxhw6Hu7hXZ+H9pTz2YEpdFGJkvddExx9p+V/rVqC
         uibWBvk+pS+DDrCDSLmsHRthZkd6aul5crMjsbmwKvceoi1DEVxLvym2epsN8UfIzvhv
         AjQgwzh+fE0j2TxKbDj7uLSjWskACZqAPSd0EsfH+uVW/aORWZKpuylU3kHBYRDrR+S1
         qTmQ==
X-Gm-Message-State: AOAM531Gn8C9KVTSG63z+wKrhDzZ7X5WPz4JyCoF02G2buHYDP1uKYiF
        OvWcFHagnOOQ9UaebS4VCkA=
X-Google-Smtp-Source: ABdhPJzPNTapOnGwPOHIYhb06+9Hwzw7bEKzCk9gSFeJdi/OELTOtBibPltvV0WujChWAU5/CBYiig==
X-Received: by 2002:a5d:4e50:: with SMTP id r16mr171061wrt.124.1623354791967;
        Thu, 10 Jun 2021 12:53:11 -0700 (PDT)
Received: from smtpclient.apple (190.1.93.209.dyn.plus.net. [209.93.1.190])
        by smtp.gmail.com with ESMTPSA id v16sm4653321wrr.6.2021.06.10.12.53.11
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 10 Jun 2021 12:53:11 -0700 (PDT)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.100.0.2.22\))
Subject: Re: [PATCH] function mana_hwc_create_wq leaks memory
From:   Dhiraj Shah <find.dhiraj@gmail.com>
In-Reply-To: <BYAPR21MB127087B408352336E0A8BF2ABF359@BYAPR21MB1270.namprd21.prod.outlook.com>
Date:   Thu, 10 Jun 2021 20:53:10 +0100
Cc:     KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Shachar Raindel <shacharr@microsoft.com>,
        Colin Ian King <colin.king@canonical.com>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <98DC11D9-668E-47F2-891C-6F41E70BD5F4@gmail.com>
References: <20210610152925.18145-1-find.dhiraj@gmail.com>
 <BYAPR21MB1270FC995760BE925179F353BF359@BYAPR21MB1270.namprd21.prod.outlook.com>
 <BYAPR21MB127087B408352336E0A8BF2ABF359@BYAPR21MB1270.namprd21.prod.outlook.com>
To:     Dexuan Cui <decui@microsoft.com>
X-Mailer: Apple Mail (2.3654.100.0.2.22)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dexuan,

Thanks for the feedback.

You are right saying =E2=80=98mana_hwc_destroy_wq' free=E2=80=99s up the =
queue.=20

However for example if  function 'mana_hwc_alloc_dma_buf' fails it will =
goto =E2=80=98out' and  call  =E2=80=98mana_hwc_destroy_wq', the value =
'hwc_wq->gdma_wq' is still not assigned at this point. In the  =
=E2=80=98mana_hwc_destroy_wq' function i see it checks for =
'hwc_wq->gdma_wq' before calling, =E2=80=98mana_gd_destroy_queue', which =
makes me think queue is still not freed.

Please let me know if i am missing something.

Regards,
/Dhiraj

> On 10 Jun 2021, at 18:28, Dexuan Cui <decui@microsoft.com> wrote:
>=20
>> From: Dexuan Cui <decui@microsoft.com>
>> Sent: Thursday, June 10, 2021 10:18 AM
>> ...
>>> diff --git a/drivers/net/ethernet/microsoft/mana/hw_channel.c
>>> b/drivers/net/ethernet/microsoft/mana/hw_channel.c
>>> index 1a923fd99990..4aa4bda518fb 100644
>>> --- a/drivers/net/ethernet/microsoft/mana/hw_channel.c
>>> +++ b/drivers/net/ethernet/microsoft/mana/hw_channel.c
>>> @@ -501,8 +501,10 @@ static int mana_hwc_create_wq(struct
>>> hw_channel_context *hwc,
>>> 	*hwc_wq_ptr =3D hwc_wq;
>>> 	return 0;
>>> out:
>>> -	if (err)
>>> +	if (err) {
>>=20
>> Here the 'err' must be non-zero. Can you please remove this 'if'?
>>=20
>>> +		kfree(queue);
>>> 		mana_hwc_destroy_wq(hwc, hwc_wq);
>>> +	}
>>> 	return err;
>>> }
>>=20
>> Reviewed-by: Dexuan Cui <decui@microsoft.com>
>=20
> Hi Dhiraj,
> I checked the code again and it looks like your patch is actually
> unnecessary as IMO there is no memory leak here: the 'queue'
> pointer is passed to mana_hwc_destroy_wq() as hwc_wq->gdma_wq,
> and is later freed in mana_gd_destroy_queue() ->
> mana_gd_destroy_queue().
>=20
> The 'if' test can be removed as the 'err's is always non-zero there.
>=20
> Thanks,
> Dexuan

