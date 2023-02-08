Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A743D68EE20
	for <lists+netdev@lfdr.de>; Wed,  8 Feb 2023 12:41:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230260AbjBHLlv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Feb 2023 06:41:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230010AbjBHLlu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Feb 2023 06:41:50 -0500
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EF105FD3
        for <netdev@vger.kernel.org>; Wed,  8 Feb 2023 03:41:48 -0800 (PST)
Received: by mail-ed1-x531.google.com with SMTP id u21so20042663edv.3
        for <netdev@vger.kernel.org>; Wed, 08 Feb 2023 03:41:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=jcIn8+VMtubzNztQ4vQWYJa3lgivNvHbB4ZS7fmzBy8=;
        b=OJF1aERB7vxxdHvnlPRkgULZtKcRX3HBthCThqCNjTSDvYXrFfbgfCR6uZGt9mqUZe
         OIIBufMnInFbrIA3rwQE0TYlYoI4p8d4Fzi+cmKVauo3dj19Y2+ou4QD9R9mBKiUAjwE
         RzOcXyg0smqFQdygseWN0TxWzJ5xgP19h0unOzsWb0/qubzqOfTRovY9+piZEpuCjlXR
         0buFg+mRBgsKp2Rvh9kNP13gwbKYjbF8KB61ARB6Wer1oU0TidF6+swXCF9EJqvKvMIj
         5d5N44MIe1yMYTckFdGrnPDnqJpNpUhyQtpNpzgqSybUtEQUWoo5AB5joOkNWm+Oid/i
         fXLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jcIn8+VMtubzNztQ4vQWYJa3lgivNvHbB4ZS7fmzBy8=;
        b=Q9p0igfVz7n8/+k7ofYC5ySMGhhMkuqEUDzRTZwBDBkYG1gwPkJYmuhqewVnoGVjA/
         5jxrS/fzMiY79sS8oUIDMS0KYDqxQwR0oeUm17CFwEXHK5ylFGmxMHBkMJ4ZoF6y98oq
         EAseXMWZFZfTlsJHlXcpNZRfNgJsJ9xCc8jY8kEy4jcsJNrhYrwbPLPi6QLkuKin5ZGV
         Fnk8wCmhGwYyZlt5vBR4jgzFRCG7cKl78bhVwVyAaZJigO7aAPSE2vnBvqdLdWYHeoiN
         oRYwer5wJHS2PwWqwVp4V+MMCmUB31pvuqo02uzlIgGUiOOQzgeTb8QPW8OI4ObtKrIN
         n4OQ==
X-Gm-Message-State: AO0yUKXTdyO9xYhR/XNuHi3cz/bmjPRXtbdTSmmym0f3JGfyt+sJutPk
        6OC+mXRnSeUZ15CKfjAZzCUmsA==
X-Google-Smtp-Source: AK7set+rBApBIkU/mweFGN/H8h5/1Gfe+al2zO2VLKPL1snLt9EIiHzq12DTKbqiSRZNLWMtRhG9GA==
X-Received: by 2002:a50:9f85:0:b0:4aa:abdf:405a with SMTP id c5-20020a509f85000000b004aaabdf405amr8354370edf.33.1675856507559;
        Wed, 08 Feb 2023 03:41:47 -0800 (PST)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id k10-20020aa7c04a000000b0049e09105705sm7662239edo.62.2023.02.08.03.41.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Feb 2023 03:41:46 -0800 (PST)
Date:   Wed, 8 Feb 2023 12:41:45 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Simon Horman <simon.horman@corigine.com>
Cc:     Leon Romanovsky <leon@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Michael Chan <michael.chan@broadcom.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Gal Pressman <gal@nvidia.com>,
        Saeed Mahameed <saeed@kernel.org>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Edward Cree <ecree.xilinx@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>, Fei Qin <fei.qin@corigine.com>,
        netdev@vger.kernel.org, oss-drivers@corigine.com
Subject: Re: [PATCH/RFC net-next 1/2] devlink: expose port function commands
 to assign VFs to multiple netdevs
Message-ID: <Y+OKeVE9jaoL4qhf@nanopsycho>
References: <20230206153603.2801791-1-simon.horman@corigine.com>
 <20230206153603.2801791-2-simon.horman@corigine.com>
 <20230206184227.64d46170@kernel.org>
 <Y+OFspnA69XxCnpI@unreal>
 <Y+OJVW8f/vL9redb@corigine.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y+OJVW8f/vL9redb@corigine.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wed, Feb 08, 2023 at 12:36:53PM CET, simon.horman@corigine.com wrote:
>On Wed, Feb 08, 2023 at 01:21:22PM +0200, Leon Romanovsky wrote:
>> On Mon, Feb 06, 2023 at 06:42:27PM -0800, Jakub Kicinski wrote:
>> > On Mon,  6 Feb 2023 16:36:02 +0100 Simon Horman wrote:
>> > > +VF assignment setup
>> > > +---------------------------
>> > > +In some cases, NICs could have multiple physical ports per PF. Users can assign VFs to
>> > > +different ports.
>> > 
>> > Please make sure you run make htmldocs when changing docs,
>> > this will warn.
>> > 
>> > > +- Get count of VFs assigned to physical port::
>> > > +
>> > > +    $ devlink port show pci/0000:82:00.0/0
>> > > +    pci/0000:82:00.0/0: type eth netdev enp130s0np0 flavour physical port 0 splittable true lanes 4
>> > 
>> > Physical port has VFs? My knee jerk reaction is that allocating
>> > resources via devlink is fine but this seems to lean a bit into
>> > forwarding. How do other vendors do it? What's the mapping of VFs
>> > to ports?
>> 
>> I don't understand the meaning of VFs here. If we are talking about PCI
>> VFs, other vendors follow PCI spec "9.3.3.3.1 VF Enable" section, which
>> talks about having one bit to enable all VFs at once. All these VFs will
>> have separate netdevs.
>
>Yes, that is the case here too (before and after).
>
>What we are talking about is the association of VFs to physical ports
>(in the case where a NIC has more than one physical port).

What is "the association"?

