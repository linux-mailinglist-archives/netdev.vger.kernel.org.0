Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A14C16C9D5C
	for <lists+netdev@lfdr.de>; Mon, 27 Mar 2023 10:14:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232994AbjC0IO3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Mar 2023 04:14:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233007AbjC0ION (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Mar 2023 04:14:13 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAFDE5262;
        Mon, 27 Mar 2023 01:14:08 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id l12so7691162wrm.10;
        Mon, 27 Mar 2023 01:14:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679904847;
        h=mime-version:user-agent:references:message-id:date:in-reply-to
         :subject:cc:to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=sAxLeaUVIzP7e0iTCrCqBarIP6qFQ8Y+g/OjPwf2Z+E=;
        b=Y1tgcnPkh/BJAXaO0ntB0/92QaCRzyiSrECJ02s+FFT9iRIjOjgi2Fs7WD/Ap+kQx2
         REPR0sr4i6mftuf9GwAOYlg4wW4SQqam5S3Mn24L8mbVpP5NDwuPbsfXF+gdvbH5h2lQ
         smH8zkGg7boLwNjUnNu3UYL89+htut7iS5sRqrmClLuITk5XxrHg6XnErhrZ7DfglUgR
         o//bTo137UYvagT/4Yx7deW7WJbTn0wBox678bI63zZrPZNwP02i7wtFGtmszzNkhRCb
         qsGKUX4SIre1kNjXBvefepS0Y0G+On4d/pryFuFuxM+uKcNwYaNpR+alS/hwykHOrMLI
         tEoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679904847;
        h=mime-version:user-agent:references:message-id:date:in-reply-to
         :subject:cc:to:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sAxLeaUVIzP7e0iTCrCqBarIP6qFQ8Y+g/OjPwf2Z+E=;
        b=cfbrUfqiUaGNgsyU9qP4ymPth6eJ2zQH+b+JYukffdWEXL++kDXytdHgG/CnbheWgi
         9iZL1kTvgbtnyRw5q8/8TXLCtSCeyHtUzEOerh3d1R180DSu9Ks2GOMOtTjy5WJXpnTj
         E0hzM0SRP6TmmoPeXcUTR5WCRYcc6YbJz1cEJ3Hul/tozjZSAh8sp6nvLpSZnRVno8G9
         kYXMprCOGROipveTAQz9BlgFICiQBAEKqv/LJw/e4Y1oetg+JG1PV1QqgwiJsRll0CMO
         AqLCux2Hb55W5FL9JyXjZ8afFTkepOuJDXdG6H+DqZIEx695jJyii7QoRDoAcXaina+W
         LRlw==
X-Gm-Message-State: AAQBX9dRqkgY3mO2DMIGoZgrqUq8JnUvssShiQzK58rkHqhz2SfNMFvd
        npqOYsQ/fmWsEuBZ0lrTOFI=
X-Google-Smtp-Source: AKy350YrJKLG5Ofrdx6vllxk1RdFYBlAHV8EQoWv6sn69/ofN1Sj/jvGaGhp/88y8I2K3JaQYwejbQ==
X-Received: by 2002:adf:dccc:0:b0:2d2:29a4:4457 with SMTP id x12-20020adfdccc000000b002d229a44457mr8390439wrm.13.1679904847155;
        Mon, 27 Mar 2023 01:14:07 -0700 (PDT)
Received: from imac ([2a02:8010:60a0:0:7887:5530:69a2:a11f])
        by smtp.gmail.com with ESMTPSA id a3-20020adffb83000000b002c561805a4csm24354559wrr.45.2023.03.27.01.14.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Mar 2023 01:14:06 -0700 (PDT)
From:   Donald Hunter <donald.hunter@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
        donald.hunter@redhat.com
Subject: Re: [PATCH net-next v4 4/7] tools: ynl: Add fixed-header support to
 ynl
In-Reply-To: <20230324204736.217e622b@kernel.org> (Jakub Kicinski's message of
        "Fri, 24 Mar 2023 20:47:36 -0700")
Date:   Mon, 27 Mar 2023 09:10:49 +0100
Message-ID: <m2a5zyiph2.fsf@gmail.com>
References: <20230324191900.21828-1-donald.hunter@gmail.com>
        <20230324191900.21828-5-donald.hunter@gmail.com>
        <20230324204736.217e622b@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Kicinski <kuba@kernel.org> writes:

> On Fri, 24 Mar 2023 19:18:57 +0000 Donald Hunter wrote:
>> diff --git a/Documentation/netlink/genetlink-legacy.yaml b/Documentation/netlink/genetlink-legacy.yaml
>> index d50c78b9f42d..3b8984122383 100644
>> --- a/Documentation/netlink/genetlink-legacy.yaml
>> +++ b/Documentation/netlink/genetlink-legacy.yaml
>> @@ -261,6 +261,13 @@ properties:
>>        async-enum:
>>          description: Name for the enum type with notifications/events.
>>          type: string
>> +      # Start genetlink-legacy
>> +      fixed-header: &fixed-header
>> +        description: |
>> +          Name of the structure defininig the optional fixed-length protocol header. This header is
>
> Typo in 'defininig', could you also wrap at 80 chars?
> Old school kernel style.

Will do. The spec does spill beyond 100 chars tho.


>> +          placed in a message after the netlink and genetlink headers and before any attributes.
>> +        type: string
>> +      # End genetlink-legacy
>
>>  class GenlMsg:
>> -    def __init__(self, nl_msg):
>> +    def __init__(self, nl_msg, fixed_header_members = []):
>
> spaces around = or no spaces? I don't really know myself but I'm used
> to having no spaces.

Happy to go with existing convention in the codebase and will remove spaces.

>> @@ -540,7 +555,7 @@ class YnlFamily(SpecFamily):
>>                          print('Unexpected message: ' + repr(gm))
>>                          continue
>>  
>> -                rsp.append(self._decode(gm.raw_attrs, op.attr_set.name))
>> +                rsp.append(self._decode(gm.raw_attrs, op.attr_set.name) | gm.fixed_header_attrs)
>
> nit: also line wrap?

Will do.
