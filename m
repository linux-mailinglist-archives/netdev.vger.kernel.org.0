Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9CC9050367F
	for <lists+netdev@lfdr.de>; Sat, 16 Apr 2022 14:04:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231871AbiDPL7l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Apr 2022 07:59:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230085AbiDPL7k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Apr 2022 07:59:40 -0400
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A870377F1;
        Sat, 16 Apr 2022 04:57:08 -0700 (PDT)
Received: by mail-lf1-x132.google.com with SMTP id g19so3718226lfv.2;
        Sat, 16 Apr 2022 04:57:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language
         :from:to:cc:references:in-reply-to;
        bh=KNNvGOUmtxyxeB/UY+YMQMsLMiQP9zzTJk4b8wa6Eog=;
        b=pZOK1o6vBKKEKD17hVV2Fl+XtoHcGZIpacLboJXVlA2Ms79TR8YJPbVMVxit+S+e4N
         0SOeOsMjQ6/uER8ESBWDS6WKy2Bgd0VSVrgFrbScQdrQ6fFoVlB5X9nz6CtpHzGmqCsu
         haMB5gPK50Qrx1QTh55dtkQfIcDs8Qp+BGRhGnpR4y9VqrbVFkzVFVMclEiEb9FJ3jQ9
         RaGRFykMgQCe0cAn1Woo17OhHeQ6gNRRqvn1/xstJhAYa+ddzAIHberG7+kwLQ0RFoKn
         GlOp9gSGBaRl+zFwcDtVZ6KcsRnpxddIdcmyGgApslodEkDe0bXrx30W9l8FvmGz3o37
         55/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:from:to:cc:references:in-reply-to;
        bh=KNNvGOUmtxyxeB/UY+YMQMsLMiQP9zzTJk4b8wa6Eog=;
        b=dTNHVapxSU0wxkKuYjebdeJfMPspzSMpe6adaVz+LyR8qYZbj9cTHdzWzodH7p66vM
         VyrFbuK2jc0/BH5siurszNdc+f4MMThor1Z45CvBAbvttSpl8IBIr27eCVr6E4nH2IVd
         NwxKSk4zOg3uyPcdBvj/rA2A9QT5QshGxbouOPZq5eL5TT/iSKRMhQ8rkZ9zNOq2bBWI
         82WSsGVK0K1gwAO24avGRzA8BnnP/hmrDIAaUgL9Au9PhzdiprvbxRDn/c8tthVGWSiP
         bpOx1nHk63zuiQyOBOteCjoSR0Zj3IJiDyC57ISfvUUi2cTriR1fnUDdDxSkU8epVBy5
         hV8A==
X-Gm-Message-State: AOAM532h+tZIK0lYCpS4+Cfy8tXrlmxQZtJOkN/XEoI8Y3ZMcqX+87Fo
        6M+k6Y9rrTyNOK9OhIjoJx4=
X-Google-Smtp-Source: ABdhPJxAlc4NLnDXnaQznAH84ak/ZTYnLVqsLdHs3nojftoOqh8GA3K57VZqlUl2KRVcMwXPWkm1yQ==
X-Received: by 2002:a05:6512:22d5:b0:46b:c423:826a with SMTP id g21-20020a05651222d500b0046bc423826amr2209397lfu.162.1650110226860;
        Sat, 16 Apr 2022 04:57:06 -0700 (PDT)
Received: from [192.168.1.11] ([94.103.225.17])
        by smtp.gmail.com with ESMTPSA id t4-20020a192d44000000b0047021deb3b7sm255214lft.9.2022.04.16.04.57.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 16 Apr 2022 04:57:05 -0700 (PDT)
Message-ID: <b97f3990-3472-3073-9ab4-6a3e8ba1a899@gmail.com>
Date:   Sat, 16 Apr 2022 14:57:04 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH] net: ax88179: add proper error handling of usb read
 errors
Content-Language: en-US
From:   Pavel Skripkin <paskripkin@gmail.com>
To:     David Kahurani <k.kahurani@gmail.com>
Cc:     netdev@vger.kernel.org,
        syzbot <syzbot+d3dbdf31fbe9d8f5f311@syzkaller.appspotmail.com>,
        davem@davemloft.net, jgg@ziepe.ca, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        Phillip Potter <phil@philpotter.co.uk>,
        syzkaller-bugs@googlegroups.com, arnd@arndb.de,
        Dan Carpenter <dan.carpenter@oracle.com>
References: <20220416074817.571160-1-k.kahurani@gmail.com>
 <65c52645-26e8-ff2b-86dc-b5dd697317f9@gmail.com>
 <CAAZOf27Q-QQ51pGO1gFETNR0ASg6zmxF4HUFUVn77oL3Cs7LEg@mail.gmail.com>
 <18f52ad1-0928-389c-46fc-dd050b73a4cd@gmail.com>
In-Reply-To: <18f52ad1-0928-389c-46fc-dd050b73a4cd@gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------TsVIXk9mUbnYCfUBedKc4xMx"
X-Spam-Status: No, score=-6.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------TsVIXk9mUbnYCfUBedKc4xMx
Content-Type: multipart/mixed; boundary="------------4MQ1cyWs5gcMOibVqInZjBpb";
 protected-headers="v1"
From: Pavel Skripkin <paskripkin@gmail.com>
To: David Kahurani <k.kahurani@gmail.com>
Cc: netdev@vger.kernel.org,
 syzbot <syzbot+d3dbdf31fbe9d8f5f311@syzkaller.appspotmail.com>,
 davem@davemloft.net, jgg@ziepe.ca, kuba@kernel.org,
 linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
 Phillip Potter <phil@philpotter.co.uk>, syzkaller-bugs@googlegroups.com,
 arnd@arndb.de, Dan Carpenter <dan.carpenter@oracle.com>
Message-ID: <b97f3990-3472-3073-9ab4-6a3e8ba1a899@gmail.com>
Subject: Re: [PATCH] net: ax88179: add proper error handling of usb read
 errors
References: <20220416074817.571160-1-k.kahurani@gmail.com>
 <65c52645-26e8-ff2b-86dc-b5dd697317f9@gmail.com>
 <CAAZOf27Q-QQ51pGO1gFETNR0ASg6zmxF4HUFUVn77oL3Cs7LEg@mail.gmail.com>
 <18f52ad1-0928-389c-46fc-dd050b73a4cd@gmail.com>
In-Reply-To: <18f52ad1-0928-389c-46fc-dd050b73a4cd@gmail.com>

--------------4MQ1cyWs5gcMOibVqInZjBpb
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gNC8xNi8yMiAxNDo1MywgUGF2ZWwgU2tyaXBraW4gd3JvdGU6DQo+IE5vLCB0aGlzIHdp
bGwgYnJlYWsgdGhlIGRyaXZlci4gVGhpcyBmdW5jdGlvbiBzaG91bGQgc2V0IG1hYyBhZGRy
ZXNzIGluDQo+IG5ldGRldiBzdHJ1Y3R1cmUgYW5kIGlmIHJlYWQgZnJvbSBkZXZpY2UgZmFp
bHMgY29kZSBjYWxscw0KPiANCj4gCWV0aF9od19hZGRyX3NldChkZXYtPm5ldCwgbWFjKTsN
Cj4gDQoNCldvb3BzLCBJIG1lYW4gZXRoX2h3X2FkZHJfcmFuZG9tKGRldi0+bmV0KSBvZiBj
b3Vyc2UNCg0KSSBhbSBzb3JyeSBmb3IgY29uZnVzaW9uDQoNCg0KDQoNCldpdGggcmVnYXJk
cywNClBhdmVsIFNrcmlwa2luDQo=

--------------4MQ1cyWs5gcMOibVqInZjBpb--

--------------TsVIXk9mUbnYCfUBedKc4xMx
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEER3XL3TplLQE8Qi40bk1w61LbBA0FAmJarxAFAwAAAAAACgkQbk1w61LbBA0E
Jg/+N/9Aj99x4tgTaFvf5M/wkYc3raGaKQk//Ta8rB1DPcBYHBQts7jj3G9IRWfUctDKtDfXfc+E
VfT6+fKWFeTGg8ip9lzUs2vpc1u3e3IXOLE13i17tehA4YcuWIWdr8QUi/SiMgii7lR82EqnGAXJ
RRhJYq1yfqIVFCusntOF2c12yXk+U3eyiDSoTtaMipFEV9Jg+O1jMLrigScoeTJYMt7a3i6oFwSn
r2/SI1bxqKyWwK5eI5O/jtKeL+tTk95b3HplOLpFmNUJU7YgNjbSnua0Nj3hyT3sfJ45korFNbKl
pdQyE04H5EMWkkbZNpTLwGkj8ZT7COC1Y2oAnB/WfLvKqMRmVyO9eJ78jig0PMxhB93yxok+nE8E
Dyzk4UcLRgQ1QyzGzMarc6vk27mzS2A80LMB/hsHyNsAC8qbOV+SGh/bOo2urXw/vMmJ14Hgv8g9
4hx3qGHycJgroPkBSvqfDF93MrErHgyj5LZJnLceGYAnUlR/JbH3KLNUqFcUCFhhOIkuHZIUPVbq
KuGBnyo2i0a8BcvqEdHROgOwn/bva4RPfmI91VrpUeE1H+cMVH1uJQGRlnh59Hfb9Bfoz6SLF4R1
ve3uJGqGW8nLUWY25B6OJy6B0GA/Ts/GDeS7ssKdz9M6ToOC50HX41Y671PyZRUwKpiY5eleC9dE
zw0=
=kEl9
-----END PGP SIGNATURE-----

--------------TsVIXk9mUbnYCfUBedKc4xMx--
