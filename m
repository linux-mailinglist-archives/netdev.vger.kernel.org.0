Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD6424C8D83
	for <lists+netdev@lfdr.de>; Tue,  1 Mar 2022 15:17:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234241AbiCAOSP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Mar 2022 09:18:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232871AbiCAOSP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Mar 2022 09:18:15 -0500
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A788538B3
        for <netdev@vger.kernel.org>; Tue,  1 Mar 2022 06:17:32 -0800 (PST)
Received: from [192.168.1.214] (dynamic-089-012-174-087.89.12.pool.telefonica.de [89.12.174.87])
        by linux.microsoft.com (Postfix) with ESMTPSA id A383720B7178;
        Tue,  1 Mar 2022 06:17:31 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com A383720B7178
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1646144252;
        bh=sxGqDWjUtJ0f8Fl3fVaLNPrNq77MZYQVOO+j62RTOBw=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=Hw353Wi5vYCXcdzojh53d/UrRv2ofmaTUj03bOHkfzF38sxrplyqHse8HJ5N4IE3j
         VTkO6tsNYidyDOdMBel0uL8YmD0lxMF9vNh7+LOu/oVmL6eihKchOXluvbZ8w4YSzE
         jZdSBLHXBNLsoN4Ownl77IRY0oBSp3k3owKoMVS4=
Subject: Re: [PATCH 1/2] Revert "xfrm: interface with if_id 0 should return
 error"
To:     Eyal Birger <eyal.birger@gmail.com>
Cc:     netdev@vger.kernel.org,
        Steffen Klassert <steffen.klassert@secunet.com>
References: <20220301131512.1303-1-kailueke@linux.microsoft.com>
 <CAHsH6Gtzaf2vhSv5sPpBBhBww9dy8_E7c0utoqMBORas2R+_zg@mail.gmail.com>
From:   =?UTF-8?B?S2FpIEzDvGtl?= <kailueke@linux.microsoft.com>
Message-ID: <d5e58052-86df-7ffa-02a0-fc4db5a7bbdf@linux.microsoft.com>
Date:   Tue, 1 Mar 2022 15:17:23 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <CAHsH6Gtzaf2vhSv5sPpBBhBww9dy8_E7c0utoqMBORas2R+_zg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Spam-Status: No, score=-19.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,ENV_AND_HDR_SPF_MATCH,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,
> Whereas 8dce43919566 ("xfrm: interface with if_id 0 should return error")
> involves xfrm interfaces which don't appear in the pull request.
>
> In which case, why should that commit be reverted?

Correct me if I misunderstood this but reading the commit message it is
explicitly labeled as a behavior change for userspace:

    With this commit:
     ip link add ipsec0  type xfrm dev lo  if_id 0
     Error: if_id must be non zero.

Changing behavior this way is from my understanding a regression because
it breaks programs that happened to work before, even if they worked
incorrect (cf. https://lwn.net/Articles/726021/ "The current process for
Linux development says that kernel patches cannot break programs that
rely on the ABI. That means a program that runs on the 4.0 kernel should
be able to run on the 5.0 kernel, Levin said.").

Regards,
Kai

