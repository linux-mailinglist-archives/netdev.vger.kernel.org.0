Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4EB04CC0EB
	for <lists+netdev@lfdr.de>; Fri,  4 Oct 2019 18:38:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729440AbfJDQiG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Oct 2019 12:38:06 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:33342 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728219AbfJDQiG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Oct 2019 12:38:06 -0400
Received: by mail-pf1-f193.google.com with SMTP id q10so4251577pfl.0
        for <netdev@vger.kernel.org>; Fri, 04 Oct 2019 09:38:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Ff2TtPDgelOhF/V4IJgzbVbqgE+IJacVffOJshj6t4w=;
        b=M6omj/VeS76hxVs+EZG54oHDzJFmPkF0IJUtU0VV6BZN89r3g6XSEBiOtfaTDp5cxW
         6zljgnc8rG+6Er3OtDDgzqioJ0hvIkKMMnTnLol1tge5MouKASgOCkVDJOWrrgiE/LMm
         CuYRhnw7zLnnvc0bYyAnzTThaboyLe2AYHQ4Uy4a/KlZMFYF652BTUYMDblI0kuBTq38
         m2XdLxjrLpcm2AxIV4xqEZo2SB4D4KjrJ6omqdswmnvWvXL+n8C+k7W+1BT2Y2px4nO0
         MQJZm7imdMmWM61oTOa40wcTMARNLKg75dZ4eo2SbR/AmPXrA1Fsrxh4zFUinwecP+yD
         RM0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Ff2TtPDgelOhF/V4IJgzbVbqgE+IJacVffOJshj6t4w=;
        b=e/RXk1RrQXPB7t03QRF39tRdOcWca3HPrnLEc1UQU8x6bBhu8WtDUNtbfE7yrlq/kQ
         EIYqZQKkmj3tAQBU8f9QT6AABJcsjyfi9FZ0LqB3XI/a6dqaTVgauWw2ZTUGjUj/YHft
         bf5clJ7pOTDm9FrvRJNwIDfO8ougvL57VaV7ADjzbdQJ/bZTWO/fUprsyo/rCWsB074u
         DrseY1UhKdVPpnW8cRUEEMZQwObCejNQ0cidXw7F7UtjWHvlSI4mqT0UNXbcoBQbztk3
         dwcTJwAeNboD2gGZVfjqBDGUFi17Vrd+8PpABpUb0QY0JoVkRN+Z9vDA1NF3ZGZ6dum6
         CxgQ==
X-Gm-Message-State: APjAAAUMjaGYAeMAoVq2ukedDqnBwMA8alTnbUwbCPBgrAWqHJOcJ+dQ
        O8SkID3ptCg7pwFXzvrhbxo=
X-Google-Smtp-Source: APXvYqz5tBV5kvQW0wJ0lBoR+PcZfkPOsTyLvBbUalEBRZfhxr2L4LWYHphCInTS2HtsbrKGIX7/bA==
X-Received: by 2002:aa7:953c:: with SMTP id c28mr18138569pfp.106.1570207085801;
        Fri, 04 Oct 2019 09:38:05 -0700 (PDT)
Received: from dahern-DO-MB.local (c-73-169-115-106.hsd1.co.comcast.net. [73.169.115.106])
        by smtp.googlemail.com with ESMTPSA id z4sm9013054pfn.45.2019.10.04.09.38.04
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 04 Oct 2019 09:38:04 -0700 (PDT)
Subject: Re: [RFC PATCH net-next 12/15] ipv4: Add "in hardware" indication to
 routes
To:     Ido Schimmel <idosch@idosch.org>, roopa@cumulusnetworks.com
Cc:     Jiri Pirko <jiri@resnulli.us>, netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jiri Pirko <jiri@mellanox.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        mlxsw <mlxsw@mellanox.com>, Ido Schimmel <idosch@mellanox.com>
References: <20191002084103.12138-1-idosch@idosch.org>
 <20191002084103.12138-13-idosch@idosch.org>
 <CAJieiUiEHyU1UbX_rJGb-Ggnwk6SA6paK_zXvxyuYJSrah+8vg@mail.gmail.com>
 <20191002182119.GF2279@nanopsycho>
 <1eea9e93-dbd9-8b50-9bf1-f8f6c6842dcc@gmail.com>
 <20191003053750.GC4325@splinter>
 <e4f0dbf6-2852-c658-667b-65374e73a27d@gmail.com>
 <20191004144340.GA15825@splinter>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <0ba448e3-3c27-d440-ee16-55f778b57bb1@gmail.com>
Date:   Fri, 4 Oct 2019 10:38:03 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191004144340.GA15825@splinter>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/4/19 8:43 AM, Ido Schimmel wrote:
>> Sounds like there are 2 cases for prefixes that should be flagged to the
>> user -- "offloaded" (as in traffic is offloaded) and  "in_hw" (prefix is
>> in hardware but forwarding is not offloaded).
> Sounds good. Are you and Roopa OK with the below?
> 
> RTM_F_IN_HW - route is in hardware
> RTM_F_OFFLOAD - route is offloaded
> 
> For example, host routes will have the first flag set, whereas prefix
> routes will have both flags set.

if "offload" always includes "in_hw", then are both needed? ie., why not
document that offload means in hardware with offloaded traffic, and then
"in_hw" is a lesser meaning - only in hardware with a trap to CPU?

> 
> Together with the existing offload flags for nexthops and neighbours
> this provides great visibility into the entire offload process.

