Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3C101F50BD
	for <lists+netdev@lfdr.de>; Wed, 10 Jun 2020 11:04:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726980AbgFJJD7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jun 2020 05:03:59 -0400
Received: from sitav-80046.hsr.ch ([152.96.80.46]:41178 "EHLO
        mail.strongswan.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726867AbgFJJD6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Jun 2020 05:03:58 -0400
Received: from [152.96.214.51] (unknown [152.96.214.51])
        by mail.strongswan.org (Postfix) with ESMTPSA id E6BC0404F1;
        Wed, 10 Jun 2020 11:03:55 +0200 (CEST)
Subject: Re: [PATCH net v3 3/3] esp, ah: modernize the crypto algorithm
 selections
To:     Eric Biggers <ebiggers@kernel.org>, netdev@vger.kernel.org
Cc:     linux-crypto@vger.kernel.org, Corentin Labbe <clabbe@baylibre.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>
References: <20200610005402.152495-1-ebiggers@kernel.org>
 <20200610005402.152495-4-ebiggers@kernel.org>
From:   Tobias Brunner <tobias@strongswan.org>
Autocrypt: addr=tobias@strongswan.org; prefer-encrypt=mutual; keydata=
 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
Message-ID: <c87f1edb-4130-a4a9-2915-ae5d55302f0a@strongswan.org>
Date:   Wed, 10 Jun 2020 11:03:55 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200610005402.152495-4-ebiggers@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Eric,

> +	  Note that RFC 8221 considers AH itself to be "NOT RECOMMENDED".  It is
> +	  better to use ESP only, using an AEAD cipher such as AES-GCM.

What's NOT RECOMMENDED according to the RFC is the combination of ESP+AH
(i.e. use ESP only for confidentiality and AH for authentication), not
AH by itself (although the RFC keeps ENCR_NULL as a MUST because ESP
with NULL encryption is generally preferred over AH due to NATs).

Regards,
Tobias
