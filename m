Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1C670D36C9
	for <lists+netdev@lfdr.de>; Fri, 11 Oct 2019 03:17:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727845AbfJKBRL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Oct 2019 21:17:11 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:33914 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727518AbfJKBRK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Oct 2019 21:17:10 -0400
Received: by mail-qt1-f196.google.com with SMTP id 3so11624795qta.1
        for <netdev@vger.kernel.org>; Thu, 10 Oct 2019 18:17:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=FRAhjU6zbOujsKrU9OXTc20iXWxJB1PbXELLM5EnWz4=;
        b=P1TDOu+hLEOcYZdp+RsC60/WrDZp/0xsV3XEPvMb+X1f2sb8KVh050ChS/DzqZuxu8
         LfIixQWkK/AwqxVuEVLOrPZjVGRc6zmnjWRM9aUwlWSTj5xkRz8xU7p99/Qvaynfepcf
         uvsihaoCaRpQWHf2MCAo0RG7xtTRnRD4nq3OsDCv6m3Xy6UY6F/0Q2e3xamg9fFlx88B
         dTEcIY4+AwFNN/rzgizAzI9XEoUwBaH7h3NhapVmfuzZWvdafnrP4nD9jdNIC6FczlsH
         zed2XaA9tN0P9Q3eDjBeau2NNwysV8CtKdbCM2i44OAO7zFoclfCovDLWkJ6fTixQURX
         5EjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=FRAhjU6zbOujsKrU9OXTc20iXWxJB1PbXELLM5EnWz4=;
        b=fevUx/9KKi8vdq3ORbKhijHkbQKjvcJOxUT2Yg75/N4pAaqtmpkM5IJOcL74zUt/EF
         51+jZuX8EI6ELeS7QMp7nFFSIlmRkVeQ4KPBX7azuWoHqEVec4fZue3Ui9NE/Qb7ENpR
         QVlnKF49DmMA52L9Y0wSteHn7q44co6ErPAEjoqZ1naEin8/yXfi3buK/ddLy0dQBv9U
         /Qt0FZikG9x4XRC7NwgbK1jMEl9/qxBtLJ6xVCbpuk+UTXFpvq6qdY9dXIz/i7DBxNI8
         csYsI4TYeofk3wRocIXCYRgry8WjTLn6+JMFL49+WKC5y4puiFZ8AyL54JbMsdiNhlFU
         3yfQ==
X-Gm-Message-State: APjAAAUq8v3dja9dwpK8mmRqmRgyZfSrzrGRb5XKnxMvOuhnFUz7TV7i
        WVVwPEoC4ILLasi6kfjHmb4CtQ==
X-Google-Smtp-Source: APXvYqzOjSHMUU98eUi/w1xmBfaHzCT2guSL+N5oE5fPyX4+S+M5Qlk63IT5XbmdeS8oaoRfnXpgbA==
X-Received: by 2002:ac8:7557:: with SMTP id b23mr14086447qtr.384.1570756628331;
        Thu, 10 Oct 2019 18:17:08 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id a190sm3908987qkf.118.2019.10.10.18.17.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Oct 2019 18:17:08 -0700 (PDT)
Date:   Thu, 10 Oct 2019 18:16:51 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Vijay Khemka <vijaykhemka@fb.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        YueHaibing <yuehaibing@huawei.com>, Andrew Lunn <andrew@lunn.ch>,
        Kate Stewart <kstewart@linuxfoundation.org>,
        "Mauro Carvalho Chehab" <mchehab+samsung@kernel.org>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "openbmc @ lists . ozlabs . org" <openbmc@lists.ozlabs.org>,
        "joel@jms.id.au" <joel@jms.id.au>,
        "linux-aspeed@lists.ozlabs.org" <linux-aspeed@lists.ozlabs.org>,
        Sai Dasari <sdasari@fb.com>
Subject: Re: [PATCH v2] ftgmac100: Disable HW checksum generation on AST2500
Message-ID: <20191010181651.5abd4c21@cakuba.netronome.com>
In-Reply-To: <4B7340B5-C35C-4B18-8D8C-B5B8D16BA551@fb.com>
References: <20190911194453.2595021-1-vijaykhemka@fb.com>
        <4B7340B5-C35C-4B18-8D8C-B5B8D16BA551@fb.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 10 Oct 2019 19:20:47 +0000, Vijay Khemka wrote:
> Resending this patch again.=20

Perhaps I'm missing context but what's the intention here?

In case this is resubmitting the patch for inclusion in the upstream
kernel you need to send it out properly with git send-email or such..

> =EF=BB=BFOn 9/11/19, 1:05 PM, "Vijay Khemka" <vijaykhemka@fb.com> wrote:
>=20
>     HW checksum generation is not working for AST2500, specially with IPV6
>     over NCSI. All TCP packets with IPv6 get dropped. By disabling this
>     it works perfectly fine with IPV6. As it works for IPV4 so enabled
>     hw checksum back for IPV4.
>    =20
>     Verified with IPV6 enabled and can do ssh.
>    =20
>     Signed-off-by: Vijay Khemka <vijaykhemka@fb.com>
