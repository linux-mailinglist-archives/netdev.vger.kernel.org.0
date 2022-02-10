Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC0A44B1037
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 15:21:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242791AbiBJOVD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 09:21:03 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:38194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238798AbiBJOVC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 09:21:02 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96354F5;
        Thu, 10 Feb 2022 06:21:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DC08C618FA;
        Thu, 10 Feb 2022 14:21:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B627C004E1;
        Thu, 10 Feb 2022 14:20:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644502862;
        bh=OPamVJysT9X+tCU5hCEJCZxcXEaQ2x6awutvO1oiFc0=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=EtaQxZJqyN2b4cGyGEWmjEPZuXiBpcBqNw+tfobaM4s25xnsh1uVkaz8b/0QVQHN/
         6ppuT2sr3SCNunBk0hGU75PyTWD2a3gLyIQM9rX6MEmu19FCOpdSw9jKU8kp/Xo7Pn
         RsRA6XKSx7QPdMKqfx9i4wuLu72nEtlgalFk7lcW76lv5L2H6Y7kA9O+itqk8zlDMq
         MGtINmZnk9nW900s6SVWuh89+uvvrXED/we4bdwIkDzxt7BENd03ASECMYpH+RTC7o
         i8v3p1EJr9q4RuFt+B8u7MptkfKJm0NketNO01xy9VG6mq52J/rWE2UL/uGg04vsU4
         R2C1BJC/A7R6g==
From:   Kalle Valo <kvalo@kernel.org>
To:     =?utf-8?B?SsOpcsO0bWU=?= Pouiller <jerome.pouiller@silabs.com>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S . Miller" <davem@davemloft.net>,
        devicetree@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        linux-mmc@vger.kernel.org,
        Pali =?utf-8?Q?Roh?= =?utf-8?Q?=C3=A1r?= <pali@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: Re: [PATCH v9 05/24] wfx: add main.c/main.h
References: <20220111171424.862764-1-Jerome.Pouiller@silabs.com>
        <20220111171424.862764-6-Jerome.Pouiller@silabs.com>
        <2898137.rlL8Y2EFai@pc-42>
Date:   Thu, 10 Feb 2022 16:20:56 +0200
In-Reply-To: <2898137.rlL8Y2EFai@pc-42> (=?utf-8?B?IkrDqXLDtG1l?=
 Pouiller"'s message of "Wed,
        26 Jan 2022 09:20:05 +0100")
Message-ID: <87r18a3irb.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

J=C3=A9r=C3=B4me Pouiller <jerome.pouiller@silabs.com> writes:

> Hi Kalle,
>
> On Tuesday 11 January 2022 18:14:05 CET Jerome Pouiller wrote:
>> From: J=C3=A9r=C3=B4me Pouiller <jerome.pouiller@silabs.com>
>>=20
>> Signed-off-by: J=C3=A9r=C3=B4me Pouiller <jerome.pouiller@silabs.com>
>> ---
>>  drivers/net/wireless/silabs/wfx/main.c | 485 +++++++++++++++++++++++++
>>  drivers/net/wireless/silabs/wfx/main.h |  42 +++
>>  2 files changed, 527 insertions(+)
>>  create mode 100644 drivers/net/wireless/silabs/wfx/main.c
>>  create mode 100644 drivers/net/wireless/silabs/wfx/main.h
>>=20
> [...]
>> +/* The device needs data about the antenna configuration. This informat=
ion in
>> + * provided by PDS (Platform Data Set, this is the wording used in WF200
>> + * documentation) files. For hardware integrators, the full process to =
create
>> + * PDS files is described here:
>> + *   https:github.com/SiliconLabs/wfx-firmware/blob/master/PDS/README.md
>> + *
>> + * The PDS file is an array of Time-Length-Value structs.
>> + */
>> + int wfx_send_pds(struct wfx_dev *wdev, u8 *buf, size_t len)
>> +{
>> +	int ret, chunk_type, chunk_len, chunk_num =3D 0;
>> +
>> +	if (*buf =3D=3D '{') {
>> +		dev_err(wdev->dev, "PDS: malformed file (legacy format?)\n");
>> +		return -EINVAL;
>> +	}
>> +	while (len > 0) {
>> +		chunk_type =3D get_unaligned_le16(buf + 0);
>> +		chunk_len =3D get_unaligned_le16(buf + 2);
>> +		if (chunk_len > len) {
>> +			dev_err(wdev->dev, "PDS:%d: corrupted file\n", chunk_num);
>> +			return -EINVAL;
>> +		}
>> +		if (chunk_type !=3D WFX_PDS_TLV_TYPE) {
>> +			dev_info(wdev->dev, "PDS:%d: skip unknown data\n", chunk_num);
>> +			goto next;
>> +		}
>> +		if (chunk_len > WFX_PDS_MAX_CHUNK_SIZE)
>> + dev_warn(wdev->dev, "PDS:%d: unexpectly large chunk\n",
>> chunk_num);
>> +		if (buf[4] !=3D '{' || buf[chunk_len - 1] !=3D '}')
>> + dev_warn(wdev->dev, "PDS:%d: unexpected content\n", chunk_num);
>> +
>> +		ret =3D wfx_hif_configuration(wdev, buf + 4, chunk_len - 4);
>> +		if (ret > 0) {
>> + dev_err(wdev->dev, "PDS:%d: invalid data (unsupported
>> options?)\n",
>> +				chunk_num);
>> +			return -EINVAL;
>> +		}
>> +		if (ret =3D=3D -ETIMEDOUT) {
>> + dev_err(wdev->dev, "PDS:%d: chip didn't reply (corrupted
>> file?)\n",
>> +				chunk_num);
>> +			return ret;
>> +		}
>> +		if (ret) {
>> + dev_err(wdev->dev, "PDS:%d: chip returned an unknown error\n",
>> chunk_num);
>> +			return -EIO;
>> +		}
>> +next:
>> +		chunk_num++;
>> +		len -=3D chunk_len;
>> +		buf +=3D chunk_len;
>> +	}
>> +	return 0;
>> +}
>
> Kalle, is this function what you expected? If it is right for you, I am
> going to send it to the staging tree.

Looks better, but I don't get why '{' and '}' are still needed. Ah, does
the firmware require to have them?

--=20
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatc=
hes
