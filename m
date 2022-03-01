Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E4C34C908F
	for <lists+netdev@lfdr.de>; Tue,  1 Mar 2022 17:44:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236124AbiCAQp3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Mar 2022 11:45:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236112AbiCAQp2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Mar 2022 11:45:28 -0500
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id F1D5C33E1C
        for <netdev@vger.kernel.org>; Tue,  1 Mar 2022 08:44:47 -0800 (PST)
Received: from [192.168.1.214] (dynamic-089-012-174-087.89.12.pool.telefonica.de [89.12.174.87])
        by linux.microsoft.com (Postfix) with ESMTPSA id CCC6820B7178;
        Tue,  1 Mar 2022 08:44:46 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com CCC6820B7178
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1646153087;
        bh=e4esMS/5T0oXmhYx4MXerSxLGPrFjTNeLySYb7LEHIQ=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=mXW38wENoC7+zsTwt7EMXtl7I8NuhiNagD7L4h23BDzCSZKbVW3+cctwsqxO06xrN
         8t3cnh1ETOwrplv5M3hq2rGdFkPqeMFfSFwxa6j0VvcUYpVXw+pxEf2dYOIlUWnl+0
         llU8Ghl7niVO4CrbUz9L70l6RL0ekl/wMbNjRjpM=
Subject: Re: [PATCH 1/2] Revert "xfrm: interface with if_id 0 should return
 error"
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     Paul Chaignon <paul@cilium.io>,
        Eyal Birger <eyal.birger@gmail.com>, netdev@vger.kernel.org
References: <20220301131512.1303-1-kailueke@linux.microsoft.com>
 <CAHsH6Gtzaf2vhSv5sPpBBhBww9dy8_E7c0utoqMBORas2R+_zg@mail.gmail.com>
 <d5e58052-86df-7ffa-02a0-fc4db5a7bbdf@linux.microsoft.com>
 <CAHsH6GsxaSgGkF9gkBKCcO9feSrsXsuNBdKRM_R8=Suih9oxSw@mail.gmail.com>
 <20220301150930.GA56710@Mem>
 <dcc83e93-4a28-896c-b3d3-8d675bb705eb@linux.microsoft.com>
 <20220301161001.GV1223722@gauss3.secunet.de>
From:   Kai Lueke <kailueke@linux.microsoft.com>
Message-ID: <f2dc1c09-6e3a-0563-491b-1b8de7a8f5ef@linux.microsoft.com>
Date:   Tue, 1 Mar 2022 17:44:44 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20220301161001.GV1223722@gauss3.secunet.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
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
> In general I agree that the userspace ABI has to be stable, but
> this never worked. We changed the behaviour from silently broken to
> notify userspace about a misconfiguration.
>
> It is the question what is more annoying for the users. A bug that
> we can never fix, or changing a broken behaviour to something that
> tells you at least why it is not working.
>
> In such a case we should gauge what's the better solution. Here
> I tend to keep it as it is.

alternatives are: docs to ensure the API is used the right way, maybe a
dmesg log entry if wrong usage is detected, and filing bugs where the
API is used wrong.

The chosen way led to having this change being introduced as part of an
LTS kernel bugfix update, breaking user's clusters:
https://github.com/flatcar-linux/Flatcar/issues/626

Please rethink how you want to handle this, also for not making a
precedent here so that this repeats.

Regards,
Kai (Flatcar Container Linux team)

