Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E79556B38C2
	for <lists+netdev@lfdr.de>; Fri, 10 Mar 2023 09:32:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230458AbjCJIcv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Mar 2023 03:32:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230501AbjCJIcq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Mar 2023 03:32:46 -0500
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E942DCF69
        for <netdev@vger.kernel.org>; Fri, 10 Mar 2023 00:32:43 -0800 (PST)
Received: by mail-wr1-x42a.google.com with SMTP id f11so4260225wrv.8
        for <netdev@vger.kernel.org>; Fri, 10 Mar 2023 00:32:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112; t=1678437161;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=TJuMsbXXouOd2PyFNr2a5FEYKDBDh0dbVzmPDa8uuXQ=;
        b=6+h/WlJ0+9r4Au83MEnq08/8w4U5tFlUpoxuVfhP4Hk/GWhpYzxXmNNgZhNhkHAy7V
         Go95mYvJZRjJVPyBI9/+NGmsXycp6zYkWisxJjsPkSKjePoMinbUGa8KMWjN5q60BbLb
         XZvOk9ldHhsDmEMgz8riqM09kql7jQtFWpPZztQ8dpEFyCFccuoh9PbWTbF5Cng/YEUO
         1aCnmcoclaXl5eihxDibgxo6i659ZnQx9q3gZWmaWzIJMU/xfXgEefFiTfeRsLr8uQBi
         u5FBcIPdWTyeZb9ATBWG93GguBCwiKJIkUSfizgXSgP91lB5iHKDlRCnXzUsb8dQPfv1
         5JHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678437161;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TJuMsbXXouOd2PyFNr2a5FEYKDBDh0dbVzmPDa8uuXQ=;
        b=5iP4hXH1mS2DB52cgsaRnA2PNttj8RuSErRu5aZQ1oLnp0Nu9gkgEBxyOujSCzxi1E
         WYT1uIp9GnBNMf0apLD/jwVXyMq1E79VI77Z8nkDjbDJMUnWkXZ4njoSo0csvq5yNOTL
         kbOu1LF9TDrHbjwmWeFR7KANf+uZIPDrMS9InjsEJQaijKxLjIYMFmRyoX+qqz3f4eFG
         FCVvlIHkNr/o8XmviQW6vAJLlk5cVXVcNNhqWIrer0OA83RPbmYlNO9aoPrtTDixGIhR
         aAaed7ynVmZb5iOnxlMBuERxfjfSAa1JPcrmZ1KjrNGDrcapNSxhedkwGSLsXsd9LEqV
         cF4g==
X-Gm-Message-State: AO0yUKVqWA+GEdKcsg+/ekQrMuoQEUxVM36sNRLlavRySEKLDMbgoqXm
        MCpSQTkaYsD3vuCTb+6o9EjyjA==
X-Google-Smtp-Source: AK7set+NEnHYypfu69kmiSLZweSL5tkrj3BZK84GJmGNGQJAwL7B8Mj0bU8BqRExNd0LzOwqQIdlYw==
X-Received: by 2002:a5d:4b04:0:b0:2c5:3cfa:f7dc with SMTP id v4-20020a5d4b04000000b002c53cfaf7dcmr18236799wrq.7.1678437161334;
        Fri, 10 Mar 2023 00:32:41 -0800 (PST)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id j3-20020a5d6043000000b002c5534db60bsm1508941wrt.71.2023.03.10.00.32.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Mar 2023 00:32:40 -0800 (PST)
Date:   Fri, 10 Mar 2023 09:32:39 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Po-Hsu Lin <po-hsu.lin@canonical.com>
Cc:     linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        netdev@vger.kernel.org, idosch@mellanox.com,
        danieller@mellanox.com, petrm@mellanox.com, shuah@kernel.org,
        pabeni@redhat.com, kuba@kernel.org, edumazet@google.com,
        davem@davemloft.net
Subject: Re: [PATCHv2] selftests: net: devlink_port_split.py: skip test if no
 suitable device available
Message-ID: <ZArrJ4NJsBO6cmqA@nanopsycho>
References: <20230307150030.527726-1-po-hsu.lin@canonical.com>
 <ZAhV8nKuLVAQHQGl@nanopsycho>
 <CAMy_GT92sg4_JLPHvRpH542DPLbxOEYYoCMa2cnET1g8bz_R9Q@mail.gmail.com>
 <ZAh0fY4XoNcLTIOI@nanopsycho>
 <CAMy_GT_mLedbejcyTYkhEbuneuEvWycVi2orB82kC9ymXx0rng@mail.gmail.com>
 <ZAjS8OAFd++ThaHV@nanopsycho>
 <CAMy_GT-5DTTyXQsyHO8YX+NANeu-XvQgHG_PwQ3AeGt93CzSPg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAMy_GT-5DTTyXQsyHO8YX+NANeu-XvQgHG_PwQ3AeGt93CzSPg@mail.gmail.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, Mar 09, 2023 at 04:44:10PM CET, po-hsu.lin@canonical.com wrote:
>On Thu, Mar 9, 2023 at 2:24 AM Jiri Pirko <jiri@resnulli.us> wrote:
>>
>> Wed, Mar 08, 2023 at 03:37:41PM CET, po-hsu.lin@canonical.com wrote:
>> >On Wed, Mar 8, 2023 at 7:41 PM Jiri Pirko <jiri@resnulli.us> wrote:
>> >>
>> >> Wed, Mar 08, 2023 at 11:21:57AM CET, po-hsu.lin@canonical.com wrote:
>> >> >On Wed, Mar 8, 2023 at 5:31 PM Jiri Pirko <jiri@resnulli.us> wrote:
>> >> >>
>> >> >> Tue, Mar 07, 2023 at 04:00:30PM CET, po-hsu.lin@canonical.com wrote:
>> >> >> >The `devlink -j port show` command output may not contain the "flavour"
>> >> >> >key, an example from s390x LPAR with Ubuntu 22.10 (5.19.0-37-generic),
>> >> >> >iproute2-5.15.0:
>> >> >> >  {"port":{"pci/0001:00:00.0/1":{"type":"eth","netdev":"ens301"},
>> >> >> >           "pci/0001:00:00.0/2":{"type":"eth","netdev":"ens301d1"},
>> >> >> >           "pci/0002:00:00.0/1":{"type":"eth","netdev":"ens317"},
>> >> >> >           "pci/0002:00:00.0/2":{"type":"eth","netdev":"ens317d1"}}}
>> >> >>
>> >> >> As Jakub wrote, this is odd. Could you debug if kernel sends the flavour
>> >> >> attr and if not why? Also, could you try with most recent kernel?
>> >> >
>> >> >I did a quick check on another s390x LPAR instance which is running
>> >> >with Ubuntu 23.04 (6.1.0-16-generic) iproute2-6.1.0, there is still no
>> >> >"flavour" attribute.
>> >> >$ devlink port show
>> >> >pci/0001:00:00.0/1: type eth netdev ens301
>> >> >pci/0001:00:00.0/2: type eth netdev ens301d1
>> >> >pci/0002:00:00.0/1: type eth netdev ens317
>> >> >pci/0002:00:00.0/2: type eth netdev ens317d1
>> >> >
>> >> >The behaviour didn't change with iproute2 built from source [1]
>> >>
>> >> Could you paste output of "devlink dev info"?
>> >> Looks like something might be wrong in the kernel devlink/driver code.
>> >>
>> >The `devlink dev info` output is empty. The following output is from
>> >that Ubuntu 23.04 s390x LPAR, run as root:
>> ># devlink dev show
>> >pci/0001:00:00.0
>> >pci/0002:00:00.0
>> ># devlink dev show pci/0001:00:00.0
>> >pci/0001:00:00.0
>> ># devlink dev info
>> ># devlink dev info pci/0001:00:00.0
>>
>> Interesting, could you try ethtool -i to get the driver name?
>>
>Hi,
>
>Here you go:
>$ ethtool -i ens301
>driver: mlx4_en
>version: 4.0-0
>firmware-version: 2.35.5100
>expansion-rom-version:
>bus-info: 0001:00:00.0
>supports-statistics: yes
>supports-test: yes
>supports-eeprom-access: no
>supports-register-dump: no
>supports-priv-flags: yes
>
>$ ethtool -i ens317
>driver: mlx4_en

mlx4 is indeed not setting attrs. So you patch is needed.


>version: 4.0-0
>firmware-version: 2.35.5100
>expansion-rom-version:
>bus-info: 0002:00:00.0
>supports-statistics: yes
>supports-test: yes
>supports-eeprom-access: no
>supports-register-dump: no
>supports-priv-flags: yes
>
>HTH
>
>
>>
>> >kernel answers: Operation not supported
>> >
>> >>
