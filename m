Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB1905846FF
	for <lists+netdev@lfdr.de>; Thu, 28 Jul 2022 22:26:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230007AbiG1UX3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jul 2022 16:23:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbiG1UX1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jul 2022 16:23:27 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77C2D77549
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 13:23:26 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id mf4so5036934ejc.3
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 13:23:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject:from:to:cc;
        bh=Wp82btTC3PL7NSiKCBjHHemMNI0RT/bNjGO0+oWv6z0=;
        b=e6eiJLD+dbExoXzDcaAe80GHR3RfVrRj+NyDOsosrD/pILLx8yT98x/R0zErNtrIyw
         R6G5wc2CVuTYdf0YkT0zqBBua0+/f7wn35RHsb0BMkSujojpxs/sqe8gSjohVRPcyD/Y
         DQCGSxm7VwmRuo98Z3YPQmleBmpasr59Fb1GBuQAyMac5C9Ll6ZND+kEA2SoQqylkMUe
         nsOajds10XPlictOtFM/cHzdNcsOrKOyd8Dzfix8ykJDddBrfExG8dS9WheAJOEzzi5f
         /gFJBh2TmVuXYPS7zlvMygU3TUbJ2DplvY/BkFRx+Dy5MdsIWYTl0Tl3htTssVbL9/HU
         Ta1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject
         :x-gm-message-state:from:to:cc;
        bh=Wp82btTC3PL7NSiKCBjHHemMNI0RT/bNjGO0+oWv6z0=;
        b=VeMK+QfN5wXfbgqawwK6/+ySGyK3HZPKqte+flle/6lSPbuhbJMh3aMG22RysjQcqG
         /GwZpQwNCMarmjqfX1CfrX7/zUPTF8RjUlJrYL/vJpXsm/fIEDQL3K3N7IOCgnzgOHa8
         vg35nf5520sejF6sfAZfvupApibah+YrxksXhDj8rtnSxThASe/oSSHuOq2zPabYqa9l
         SXzLm7UD+JJVBkUZXmrWkHLY671IFG1NUPyLS/WRK9XwWo+WFxCPBjgibGmvkGVYAyaL
         Q4NUTFrwJpgr/IbMpJQolel9VRViT97+5x0m7yIoWLufnvFKgSeZBYMFV+OgedJO7OwE
         acew==
X-Gm-Message-State: AJIora/0q0JwO8VI9dV1vfDXMJ/0OkLqGBVjovlVYipYML/iXZPsS6OT
        p3tlLHW1C5Lsh2OUyvZxunC/nPx69mA=
X-Google-Smtp-Source: AGRyM1umuKrljW4BkP3ZhmMqW25yRP3IUOOywy+wmDk3TfJSjMqShA+cFGCZPaVzo7rzRJCX769p2w==
X-Received: by 2002:a17:907:b0c:b0:72b:2e30:5d4 with SMTP id h12-20020a1709070b0c00b0072b2e3005d4mr445141ejl.604.1659039804685;
        Thu, 28 Jul 2022 13:23:24 -0700 (PDT)
Received: from [192.168.1.122] (cpc159313-cmbg20-2-0-cust161.5-4.cable.virginm.net. [82.0.78.162])
        by smtp.gmail.com with ESMTPSA id fh22-20020a1709073a9600b0072fdb26bd9dsm779626ejc.173.2022.07.28.13.23.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 Jul 2022 13:23:24 -0700 (PDT)
Subject: Re: [PATCH net-next v2 12/14] sfc: set EF100 VF MAC address through
 representor
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     ecree@xilinx.com, davem@davemloft.net, pabeni@redhat.com,
        linux-net-drivers@amd.com, netdev@vger.kernel.org
References: <cover.1658943677.git.ecree.xilinx@gmail.com>
 <304963d62ed1fa5f75437d1f832830d7970f9919.1658943678.git.ecree.xilinx@gmail.com>
 <20220727201034.3a9d7c64@kernel.org>
 <67138e0a-9b89-c99a-6eb1-b5bdd316196f@gmail.com>
 <20220728092008.2117846e@kernel.org>
 <8bfec647-1516-c738-5977-059448e35619@gmail.com>
 <20220728113231.26fdfab0@kernel.org>
 <bfc03b98-53ce-077a-4627-6c8d51a29e08@gmail.com>
 <20220728122745.4cf0f860@kernel.org>
From:   Edward Cree <ecree.xilinx@gmail.com>
Message-ID: <5a4d22f2-e315-b6f4-5fb5-31134960c430@gmail.com>
Date:   Thu, 28 Jul 2022 21:23:23 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20220728122745.4cf0f860@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 28/07/2022 20:27, Jakub Kicinski wrote:
> On Thu, 28 Jul 2022 19:54:21 +0100 Edward Cree wrote:
>> The user determines which repr corresponds to which VF by looking in
>>  /sys/class/net/$VFREP/phys_port_name (e.g. "p0pf0vf0").
> 
> .. and that would also most likely be what the devlink port ID would be.
AFAICT the devlink port index is just an integer.  The example in the
 man page is
    devlink port function set pci/0000:01:00.0/1 hw_addr 00:00:00:11:22:33
Moreover, struct devlink_port has `unsigned int index`.
Though it does also have `struct devlink_port_attrs` which appears to
 encode the PF and VF numbers; I think those can be read with `devlink
 port show`.
But the whole devlink port abstraction is unnecessary when we already
 *have* an object to represent the port.

>> Indeed.  I agree that .ndo_set_mac_address() is the wrong interface.
>> But the interface I have in mind would be something like
>>     int (*ndo_set_partner_mac_address)(struct net_device *, void *);
>>  and would only be implemented by representor netdevs.
>> Idk what the uAPI/UI for that would be; probably a new `ip link set`
>>  parameter.
> 
> Yup... If only you were there during the fight over this uAPI.
> Now it's the devlink "port function" thing.
Sadly I was too busy with EF100 bring-up, and naïvely assumed that I
 could safely ignore devlink port stuff as it was so obviously going
 to be a classic Mellanox design: tasteless, overweight, and not
 cleanly mappable onto any other vendor.  Which seems to have been
 true but they've managed to make it the standard anyway by virtue
 of being there first, as usual :'(
(Yeah, I probably shouldn't publicly say things like that about
 another vendor's devs.  But I'm getting frustrated at this recurring
 pattern.)

Devlink port function *would* be useful for administering functions
 that don't have a representor.  I just can't see any good reason
 why such things should ever exist.
Maybe it's not too late to introduce my API to exist alongside it…
 though I have no idea how much work it would take to teach the
 orchestration frameworks to use it :/

-ed
