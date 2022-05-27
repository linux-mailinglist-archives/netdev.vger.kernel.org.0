Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E04DD535A53
	for <lists+netdev@lfdr.de>; Fri, 27 May 2022 09:28:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234637AbiE0H14 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 May 2022 03:27:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229925AbiE0H1x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 May 2022 03:27:53 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDC059FD3
        for <netdev@vger.kernel.org>; Fri, 27 May 2022 00:27:50 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id er5so4366780edb.12
        for <netdev@vger.kernel.org>; Fri, 27 May 2022 00:27:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=YU5oZ2LXnolOIGUy2J2dNLhXs1x9xgozHQC7h7FIjeM=;
        b=DxQ84/oJQSEeeoqXUcgVWIRQO6t8BP/sd7A+XbsK/vYWcH8YO7saQqLwBk8UWuTWeu
         KNMRxeqL1UPzHZ0wS6xK+lXJK1arLkT+w/HXxoaH2HQ9lOnUePOIPMELiMxXLOGDv1bh
         NLwoFnjeZt9BQ7sEbig6d9HdxqpMO1PypmlW0MRFYmx+FqRtjGYE6ynCDjl3tHTLnJJh
         oi8H8oaoGA+XrhSp5bMqAl9uFaBf2vxMSJC69zX+vfFGs1AHOWCVRCebom5wNeEADjxr
         DUn0E8wn+w1AR81i64qCFQw+9udO67LTUUsSZPjyJqSHooZL1O9/6P98C5GxeYaE1Ryb
         nZLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=YU5oZ2LXnolOIGUy2J2dNLhXs1x9xgozHQC7h7FIjeM=;
        b=RzMaPjHAiczrAshM+BVJVzSwph8oA8zHtH3L/Zn+/lVKQ2kB/qi3H2+n3DFOzE0OBC
         +zJ91tHgXqXNIkC+0nC4fapXGxXWN1AKTxHsHtYZ2e+UfDvJt5iCSlqMIq0TCgqezGGe
         OAQZoZitvC0osw+nwUiUi1CFIpi421IlpaRcd1ba9xmZ/O33Q02O5ujgGou6FBWjOnEF
         55iWheg5f5ckWB3T72XsdGdkTEwqshzJ0TIZ0haqp5KY2jMQZol51aqSMzQ00xGWSkxt
         n90f1jrYD8hdSiJZKZboaVo0bvqBZTJnYGzcUQQ+KyPu0lTRSv3KRRZYSJxOUBy1A96O
         B2uQ==
X-Gm-Message-State: AOAM5308817GKoelhN0MjLqq7EPSHp9th4D7NWlD9WZJbncSTyW9PKHe
        fBuEirdsVpe0AS1aHbVpuu44xQ==
X-Google-Smtp-Source: ABdhPJyKMvOluLUTEWVBBg03tYN9soKRMPWVVogBR0B3J8t8k1p6Fuv49V8p37OOF69H+ihw06EInQ==
X-Received: by 2002:a05:6402:424d:b0:42b:6da1:bd25 with SMTP id g13-20020a056402424d00b0042b6da1bd25mr23715299edb.107.1653636469398;
        Fri, 27 May 2022 00:27:49 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id u10-20020a50950a000000b0042617ba63a5sm1705856eda.47.2022.05.27.00.27.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 May 2022 00:27:48 -0700 (PDT)
Date:   Fri, 27 May 2022 09:27:47 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Ido Schimmel <idosch@idosch.org>, Ido Schimmel <idosch@nvidia.com>,
        netdev@vger.kernel.org, davem@davemloft.net, pabeni@redhat.com,
        jiri@nvidia.com, petrm@nvidia.com, dsahern@gmail.com,
        andrew@lunn.ch, mlxsw@nvidia.com
Subject: Re: [PATCH net-next 00/11] mlxsw: extend line card model by devices
 and info
Message-ID: <YpB9cwqcSAMslKLu@nanopsycho>
References: <20220502073933.5699595c@kernel.org>
 <YotW74GJWt0glDnE@nanopsycho>
 <20220523105640.36d1e4b3@kernel.org>
 <Yox/TkxkTUtd0RMM@nanopsycho>
 <YozsUWj8TQPi7OkM@nanopsycho>
 <20220524110057.38f3ca0d@kernel.org>
 <Yo3KvfgTVTFM/JHL@nanopsycho>
 <20220525085054.70f297ac@kernel.org>
 <Yo9obX5Cppn8GFC4@nanopsycho>
 <20220526103539.60dcb7f0@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220526103539.60dcb7f0@kernel.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, May 26, 2022 at 07:35:39PM CEST, kuba@kernel.org wrote:
>On Thu, 26 May 2022 13:45:49 +0200 Jiri Pirko wrote:
>> >Separate instance:
>> >
>> >	for (i = 0; i < sw->num_lcs; i++) {
>> >		devlink_register(&sw->lc_dl[i]);
>> >		devlink_line_card_link(&sw->lc[i], &sw->lc_dl[i]);
>> >	}
>> >
>> >then report that under the linecard
>> >
>> >	nla_nest_start(msg, DEVLINK_SUBORDINATE_INSTANCE);
>> >	devlink_nl_put_handle(msg, lc->devlink);
>> >	nla_nest_end(msg...)
>> >
>> >then user can update the linecard like any devlink instance, switch,
>> >NIC etc. It's better code reuse and I don't see any downside, TBH.  
>> 
>> Okay, I was thinking about this a litle bit more, and I would like to
>> explore extending the components path. Exposing the components in
>> "devlink dev info" and then using them in "devlink dev flash". LC could
>> be just one of multiple potential users of components. Will send RFC
>> soon.
>
>Feel free to send a mockup of the devlink user space outputs.
>The core code for devlink is just meaningless marshaling anyway.

Okay. So the output of devlink dev info would be extended by
"components" nest. This nest would carry array of components which
contain versions. The name of the component is openin each array member
nest:

$ devlink dev info
pci/0000:01:00.0:
  driver mlxsw_spectrum2
  versions:
      fixed:
        hw.revision A0
        fw.psid MT_0000000199
      running:
        fw.version 29.2010.2302
        fw 29.2010.2302
  components:
    lc1:
      versions:
        fixed:
          hw.revision 0
          fw.psid MT_0000000111
        running:
          fw 19.2010.1310
          ini.version 4
    lc2:
      versions:
        fixed:
          hw.revision 0
          fw.psid MT_0000000111
        running:
          fw 19.2010.1310
          ini.version 4
    someothercomponentname:
      versions:
        running:
	   fw: 888

Now on top of exsisting "devlink dev flash" cmd without component, user
may specify the component name from the array above:

$ devlink dev flash pci/0000:01:00.0 component lc1 file mellanox/fw-AGB-rel-19_2010_1312-022-EVB.mfa2

$ devlink dev flash pci/0000:01:00.0 component someothercomponentname file foo.bin

Note this is generic vehicle, line cards would benefit but it is usable
for multiple ASIC FW partitions for example.

Note that on "devlink dev flash" there is no change. This is implemented
currently. Only "devlink dev info" is extended to show the component
list.
