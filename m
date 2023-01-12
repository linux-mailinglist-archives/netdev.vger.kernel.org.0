Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5809D666F76
	for <lists+netdev@lfdr.de>; Thu, 12 Jan 2023 11:25:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236530AbjALKZi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Jan 2023 05:25:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229898AbjALKY7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Jan 2023 05:24:59 -0500
Received: from dilbert.mork.no (dilbert.mork.no [IPv6:2a01:4f9:c010:a439::d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13237DFCE;
        Thu, 12 Jan 2023 02:19:25 -0800 (PST)
Received: from canardo.dyn.mork.no ([IPv6:2a01:799:c9a:3200:0:0:0:1])
        (authenticated bits=0)
        by dilbert.mork.no (8.15.2/8.15.2) with ESMTPSA id 30CAJ5Eu1796351
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=OK);
        Thu, 12 Jan 2023 10:19:06 GMT
Received: from miraculix.mork.no ([IPv6:2a01:799:c9a:3202:549f:9f7a:c9d8:875b])
        (authenticated bits=0)
        by canardo.dyn.mork.no (8.15.2/8.15.2) with ESMTPSA id 30CAIxeI3819203
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=OK);
        Thu, 12 Jan 2023 11:18:59 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mork.no; s=b;
        t=1673518739; bh=wqU5ha1OSQ1hfmy33dTKyNWeg14ALwqaL7TIDyceZC0=;
        h=From:To:Cc:Subject:References:Date:Message-ID:From;
        b=oLNX6Efk3ClKtapi1SA0FPMsbvhzOO4BinQRNYu/xphRklxN3U/vuZlbPOYuedDK6
         EaRYaJ9x2oq2iAyYVRnIrfYl/7HLMCGrU70quvPwj/7Ez4nEivQ6JLeKBouXZRmtNE
         qtt7qkZ0buw6Qzd+z9znOQV427Osf4AsWSjindq4=
Received: (nullmailer pid 181416 invoked by uid 1000);
        Thu, 12 Jan 2023 10:18:59 -0000
From:   =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To:     Greg KH <greg@kroah.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Andre Przywara <andre.przywara@arm.com>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] r8152; preserve device list format
Organization: m
References: <87k01s6tkr.fsf@miraculix.mork.no>
        <20230112100100.180708-1-bjorn@mork.no> <Y7/dBXrI2QkiBFlW@kroah.com>
Date:   Thu, 12 Jan 2023 11:18:59 +0100
In-Reply-To: <Y7/dBXrI2QkiBFlW@kroah.com> (Greg KH's message of "Thu, 12 Jan
        2023 11:12:21 +0100")
Message-ID: <87cz7k6ooc.fsf@miraculix.mork.no>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Virus-Scanned: clamav-milter 0.103.7 at canardo
X-Virus-Status: Clean
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Greg KH <greg@kroah.com> writes:
> On Thu, Jan 12, 2023 at 11:01:00AM +0100, Bj=C3=B8rn Mork wrote:
>> This is a partial revert of commit ec51fbd1b8a2 ("r8152:
>> add USB device driver for config selection")
>>=20
>> Keep a simplified version of the REALTEK_USB_DEVICE macro
>> to avoid unnecessary reformatting of the device list. This
>> makes new device ID additions apply cleanly across driver
>> versions.
>>=20
>> Fixes: ec51fbd1b8a2 ("r8152: add USB device driver for config selection")
>> Signed-off-by: Bj=C3=B8rn Mork <bjorn@mork.no>
>> ---
>> The patch in
>> https://lore.kernel.org/lkml/20230111133228.190801-1-andre.przywara@arm.=
com/
>> will apply cleanly on top of this.
>>=20
>> This fix will also prevent a lot of stable backporting hassle.
>
> No need for this, just backport the original change to older kernels and
> all will be fine.
>
> Don't live with stuff you don't want to because of stable kernels,
> that's not how this whole process works at all :)

OK, thanks.  Will prepare a patch for stable instead then.

But I guess the original patch is unacceptable for stable as-is? It
changes how Linux react to these devces, and includes a completely new
USB device driver (i.e not interface driver).


Bj=C3=B8rn
