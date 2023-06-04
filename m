Return-Path: <netdev+bounces-7751-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E01AF721601
	for <lists+netdev@lfdr.de>; Sun,  4 Jun 2023 12:24:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 58A2B1C209F9
	for <lists+netdev@lfdr.de>; Sun,  4 Jun 2023 10:23:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 90D99522F;
	Sun,  4 Jun 2023 10:23:57 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 818D923A8
	for <netdev@vger.kernel.org>; Sun,  4 Jun 2023 10:23:57 +0000 (UTC)
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EE99DB
	for <netdev@vger.kernel.org>; Sun,  4 Jun 2023 03:23:55 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id a640c23a62f3a-974f4897d87so316950966b.0
        for <netdev@vger.kernel.org>; Sun, 04 Jun 2023 03:23:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1685874234; x=1688466234;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=vLMm5DGpDatFx+iGfB1PGjzh6TWD0e3Bij8YPp4BPK0=;
        b=Wm1OlNXNjlJ+nMigIn6SpuoagZVi8ne4aqXsakwKgRAxiTe7swwtI6PdUKORgc1ubt
         Dt1RBKJsaU+C/reLrtkvzPK5x38AxyDT5UJh6QKjzQvd+LwKYBcCk7/8rQjjQuJe8Fal
         CP7WuzOHg0AGkFfUrOOyeZqoEn4qaxKj1qw+fio1Mau2nRmttQ5E6Po0z9P2+yLyb2ix
         4BuvLfGmJ854dVwkDzHjFpFWYajEsnBMjT3slAM7z+bOU5O8/gWVAe2jgCgq4lsWVJJT
         NOYnNOmomP1q+FVSIXYvvwXN67Z4ZQR9xN2vBkWbHAhPzojJHuVXPcOqtMOEyoJDeuR5
         VZBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685874234; x=1688466234;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vLMm5DGpDatFx+iGfB1PGjzh6TWD0e3Bij8YPp4BPK0=;
        b=LCJ9QhipTlpiQ/tJFtqTQzD+0FfAYed9LP0mHWaq5sycwd0lwSlz/xGkLeBOlW2e0y
         EGwZZuYXjozmgPY0JjirXHJT8Fl5CwpeZdjL6v2R0wD1SSssNMnduYOhXB/5iECWi0uX
         jFT4io4S3XT64AVfUhHlLtV/5Nb0xxdLqm7CjCYNOYu2+WGjdlvoa8DoBeTB8UHmUCEv
         8fh3Yvl74qyQ1GZ4lNjozdRZtgB+gIid7goH9oe0vPSfAobec4+h35ZpOKQysXRBqFbo
         XaRj14bk8l2ZkdFPPSQmvkC1MQ0bWQbfNmQWR/HbaEWeshJGt7zWZNXPkIAosm2KlWDO
         lCGw==
X-Gm-Message-State: AC+VfDxyF2EvnoiVHlOAPe+GrzPdolL7LWCESeyyWnKfjQZmON/SwmlC
	0B0VqPWtx21dbXh0KctX9JsRLA==
X-Google-Smtp-Source: ACHHUZ4N/HEfFBnFfUte5O2O2Kpj1Q+ZF88Ax3cbwxbUT05XnXYC0ICFB4J+r2mgGOVOqIg7od3XSw==
X-Received: by 2002:a17:907:25c8:b0:949:cb6a:b6f7 with SMTP id ae8-20020a17090725c800b00949cb6ab6f7mr3378039ejc.56.1685874224153;
        Sun, 04 Jun 2023 03:23:44 -0700 (PDT)
Received: from [192.168.1.20] ([178.197.199.204])
        by smtp.gmail.com with ESMTPSA id a12-20020a1709063a4c00b009745c84b24bsm2995317ejf.15.2023.06.04.03.23.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 04 Jun 2023 03:23:43 -0700 (PDT)
Message-ID: <a08a3317-7f3d-02d3-adba-f01e78940d16@linaro.org>
Date: Sun, 4 Jun 2023 12:23:41 +0200
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.2
Subject: Re: [PATCH v2 3/5] dt-bindings: net: add mac-address-increment option
Content-Language: en-US
To: Paul Fertser <fercerpav@gmail.com>
Cc: Ivan Mikhaylov <fr0st61te@gmail.com>,
 Samuel Mendoza-Jonas <sam@mendozajonas.com>,
 "David S . Miller" <davem@davemloft.net>, Eric Dumazet
 <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, Rob Herring <robh+dt@kernel.org>,
 Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
 netdev@vger.kernel.org, devicetree@vger.kernel.org,
 linux-kernel@vger.kernel.org, openbmc@lists.ozlabs.org
References: <20230509143504.30382-4-fr0st61te@gmail.com>
 <6b5be71e-141e-c02a-8cba-a528264b26c2@linaro.org>
 <fc3dae42f2dfdf046664d964bae560ff6bb32f69.camel@gmail.com>
 <8de01e81-43dc-71af-f56f-4fba957b0b0b@linaro.org>
 <be85bef7e144ebe08f422bf53bb81b59a130cb29.camel@gmail.com>
 <5b826dc7-2d02-d4ed-3b6a-63737abe732b@linaro.org>
 <e6247cb39cc16a9328d9432e0595745b67c0aed5.camel@gmail.com>
 <38ae4ceb-da21-d73e-9625-1918b4ab4e16@linaro.org>
 <5d7421b6a419a9645f97e6240b1dfbf47ffcab4e.camel@gmail.com>
 <408ee74c-e6ed-d654-af04-58bd7d1e087b@linaro.org>
 <ZHUSQkXwruFQbvSC@home.paul.comp>
From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <ZHUSQkXwruFQbvSC@home.paul.comp>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 29/05/2023 22:59, Paul Fertser wrote:
> Hello Krzysztof,
> 
> Let me try to clarify a bit on the particular usecase and answer your
> questions.
> 
> Let's consider a server motherboard manufactured and sold by a single
> company. This motherboard includes I210 (Ethernet Controlleer) chip
> along with the other necessary parts right there, soldered to the PCB,
> non-replaceable. This I210 is connected to the host CPU with a PCIe
> lane and acts as a regular network adapter. In addition to that this
> chip is connected using NC-SI (management channel) to the BMC SoC
> (also permanently soldered to the board).
> 
> There is a separate EEPROM connected directly to I210 which hosts its
> firmware and many operational parameters, including the MAC
> address. This EEPROM is not anyhow accessible by the BMC (the host can
> read/write it using special protocol over PCIe). Intel expects the
> board manufacturer to embed a MAC address from the manufacturer's
> range in the EEPROM configuration. But in many cases it's desirable to
> use a separate MAC address for the BMC (then I210 acts as if it has an
> integrated switch), so the board manufacturer can, by its internal
> policy, allocate two consecutive MAC addresses to each motherboard.
> 
> The only way BMC can learn the MAC address used by I210 is by a
> special vendor-specific NC-SI command, and it can provide just a
> single address, the one used by the host. NC-SI is using Ethernet
> frames with a special type, so to execute this command the network
> driver needs to be (at least partially) functional. I do not really
> imagine nvmem getting support to read it this way.
> 
> On Wed, May 17, 2023 at 09:26:35PM +0200, Krzysztof Kozlowski wrote:
>> I would like to remind this question.
>> "why different boards with same device should have different offset/value?"
> 
> In the usecase we're aiming for the DT is describing a specific board
> from manufacturer that guarantees the offset to be correct, as none of
> the parts are replaceable and the MAC address is flashed into the
> I210 EEPROM during manufacturing.
> 
>> Let me extend this question with one more:
>> "Why for all your boards of one type, so using the same DTS, would you
>> use one value of incrementing MAC address?"
> 
> Here we assume that for all the boards supported by a particular DT
> the board manufacturer guarantees the MAC address offset by internal
> production policy, by allocating the addresses from the manufacturer's
> pool.

OK, embed such information in the commit or property description.

> 
>> But you hard-code the number, just in BMC DTS. How does it differ from
>> BMC hard-coding it differently?
>>
>> You encode policy - or software decisions - into Devicetree.
> 
> But MAC address of an Ethernet equipment is an inherent part of the
> hardware. It's just that we can't store it in an nvmem-addressable
> cell in this case, unfortunately.
> 
>> Why devices with same board cannot use different values? One board "1"
>> and second "2" for MAC increments? I am sure that one customer could
>> have it different.
> 
> You assume that the customers might be allocating their own MAC
> addresses for the network interface of a motherboard, that might be
> true if the customer gets such a board from an ODM. But such a
> customer not willing to follow the MAC address offsets policy is not
> much different from a customer who e.g. modifies flash partitions or
> storage format making the nvmem references invalid, and so requiring a
> separate DT.
> 
>> If you want to convince us, please illustrate it in a real world
>> upstreamed DTS (or explain why it cannot). Otherwise I don't see
>> justification as it is not a hardware property.
> 
> Can you please tell how you would imagine a responsible vendor tackle
> the usecase I outlined?

I would imagine him to upstream the DTS. I asked yo illustrate it. There
is still no DTS user for it so I have doubts it is used as intended.

> Guess it's not by a startup script that would
> be getting a MAC address from an interface, applying the offset, and
> then change it on the same interface?
> 
> Thank you for the review and discussion.
> 

Best regards,
Krzysztof


