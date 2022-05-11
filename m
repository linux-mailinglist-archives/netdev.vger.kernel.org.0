Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51581522C47
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 08:27:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236788AbiEKG1L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 02:27:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233219AbiEKG1K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 02:27:10 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E26C122EA71
        for <netdev@vger.kernel.org>; Tue, 10 May 2022 23:27:08 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id qe3-20020a17090b4f8300b001dc24e4da73so3126213pjb.1
        for <netdev@vger.kernel.org>; Tue, 10 May 2022 23:27:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=x1zLYmhBeI9VQ2C3yYg/lgfsb9MaFzisQ7CwqFC2jmg=;
        b=hHaUp+j61WDKc8GZukvFRmcrez5Eo+p29rj/DmGz267KV5ynjQbVgbh78lQEejCpdp
         mOQ+f7MW2xbOnb3vWbjQqUZaaa6Wu7W8fN8Ne1An/+zU4exu6yCWQdBJkslVUhZvow74
         XgF0E1YZlPM5JPTeiXucJhumMPm2ysvAuizPp8WvCz4lZ2yKKVj4iWjLLTG7746zSJKc
         l0Y3VmyURfFp973dWkCtZLl4u7dxiAwihJqC2dQSvqa6eZdXdIaGr9RYFqk56M0WnFjR
         gUOKo3URBEN0mlkzJKZGe61NlbFOn0VqXYDKl2miH/MNSD3ftSDTJ/aAgs1uAf56ktXs
         YYlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=x1zLYmhBeI9VQ2C3yYg/lgfsb9MaFzisQ7CwqFC2jmg=;
        b=iQRdUvBVUHfaW8dB73PuR8MxXeP0JCAumwKJURicWD5lmfzbiABg55GFajM9k2/ALK
         KEb2n/y9++9fwWmqrSNqkAj+Kt49fe0fCXLQZcsaX9UKWM0gKIZVdKfKCMTn91TqHEVr
         nIStio74evpu0jsSChysziY46oPWVAx426UP8G3toHgkyFIzWuwioS9blr8OItWqVdub
         ocBVZp4I22MrzVr3CNx6xQ0GxJ6TfMIifES4/ORdhLEW+7sdAQkwb4UgY66+j2VT8BL4
         kslrLmJnI1qG8BOCrbGgWqKZWr+w5wjpI9lxv7ERgO+m4ozP+ggfJ2ZFhKc2YTov8Kgd
         sHlQ==
X-Gm-Message-State: AOAM532VhtyFohR1ZNS3ZPZdPpXoF9vymIBFH/lzv58qKr5ZyMIx5h3M
        ed9DNX/dHzrhCy7atkiFVpc45iRa2Yg2BkYg
X-Google-Smtp-Source: ABdhPJwi9mUk6axdi6D2408McpV1dtefei+41H+UbmGqouDOCcK9NQYGojl152WiHURwgqbET1uz+w==
X-Received: by 2002:a17:903:20f:b0:158:d86a:f473 with SMTP id r15-20020a170903020f00b00158d86af473mr23969735plh.92.1652250428373;
        Tue, 10 May 2022 23:27:08 -0700 (PDT)
Received: from smtpclient.apple ([223.104.68.106])
        by smtp.gmail.com with ESMTPSA id a18-20020a17090a481200b001d90c8b6141sm808592pjh.53.2022.05.10.23.27.05
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 10 May 2022 23:27:08 -0700 (PDT)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3696.80.82.1.1\))
Subject: Re: [PATCH] igb_ethtool: fix efficiency issues in igb_set_eeprom
From:   lixue liang <lixue.liang5086@gmail.com>
In-Reply-To: <7963e252-05cb-349e-5902-c4e38f7e9405@intel.com>
Date:   Wed, 11 May 2022 14:26:45 +0800
Cc:     anthony.l.nguyen@intel.com, Jakub Kicinski <kuba@kernel.org>,
        intel-wired-lan@lists.osuosl.org, Netdev <netdev@vger.kernel.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <AD31AFC0-2621-4671-986A-8BCE2AA9F514@gmail.com>
References: <20220510012159.8924-1-lianglixue@greatwall.com.cn>
 <7963e252-05cb-349e-5902-c4e38f7e9405@intel.com>
To:     Jesse Brandeburg <jesse.brandeburg@intel.com>
X-Mailer: Apple Mail (2.3696.80.82.1.1)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thank you very much for replying to my question and for suggesting =
corrections.

Since the interface (igb_set_eeprom) for arbitrarily modifying the mac =
address is provided,=20
it is equivalent to providing a way to modify the mac address =
arbitrarily and cause the igb=20
driver to fail to load. Therefore, a way to restore a valid mac address =
should also be reserved,=20
so as to prevent most users from being helpless in the case of an =
invalid mac address.

Except by using tools to flash the firmware or modify the igb driver to =
continue loading under=20
an invalid mac address, however most users do not have this ability. In =
the case of invalidity,=20
the invalid mac address must be changed to a legal address, so it is =
always better to use a=20
valid mac address to continue pretending to be a network card driver =
when the mac address is invalid,
 which is always better than not being able to load the driver, such as =
the microchip network card (lan743x) driver .

I think it is worthwhile to replace the invalid mac address with a =
random valid mac address to=20
complete the igb driver loading. In response to the above problem, I =
will provide a patch on igb_main.c again..

Thank you for taking the time.

> 2022=E5=B9=B45=E6=9C=8811=E6=97=A5 03:43=EF=BC=8CJesse Brandeburg =
<jesse.brandeburg@intel.com> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> Please include netdev mailing list when mailing the maintainers of =
netdev.

