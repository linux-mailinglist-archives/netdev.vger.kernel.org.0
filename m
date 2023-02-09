Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A84AA690CB4
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 16:16:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229968AbjBIPQo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Feb 2023 10:16:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231276AbjBIPQi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Feb 2023 10:16:38 -0500
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3208661856
        for <netdev@vger.kernel.org>; Thu,  9 Feb 2023 07:16:08 -0800 (PST)
Received: by mail-wr1-x433.google.com with SMTP id j23so2159071wra.0
        for <netdev@vger.kernel.org>; Thu, 09 Feb 2023 07:16:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=FFTVQ0lSCL4mg6qKg6LInricYKa8Wc6FVObHeJpcnbU=;
        b=oPl+fQSYmc2kBkA01RlbfzYEGXYeBa+D12z/S+nBRNMuH9aU+ucoHelDhFzvPZV5e6
         1sQ2SZP4FhRbFO4qaplktccf8vS9n6h7BhJ2mOq7+f7CyJwVDK8KYWlmIV+FIwNDV2Yb
         Afg8ERKPcg7xDm4CC7AxyNN1rXJ7R30HxwgkfboH/u+bxsXirwPN+Zc9k/0rKTNwSAlr
         OPRKw5lNRX9QQVmGzRjAW/UznGboMhmkhrEF29ezj+ofgnobKtKWbBcNpfoM9cEHyB0f
         iAdvV8n+o97+xETSlKcrU+pUFrkf8Drt5afFrUPuG8KXc5Y578xwYMIbQLQmb9ykIElF
         CIuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FFTVQ0lSCL4mg6qKg6LInricYKa8Wc6FVObHeJpcnbU=;
        b=WWWWoOEFg3MQ1VOjFZ0f3TrIrboD1q1rqi/fOQNKPX+/Js/9JEwYnooIwxdFU7O/Gv
         WWZodcO/mZPa8wT3lxgxqmMzR+KC070cdvzcfA5ru1pRAv5QGRVHQfT2M/uSJ3fLgljQ
         pFAC0twopMsgaDL8zZzlflTqgKWYwOq8JAnN4V1t7S/Gtv68x5ZMTBSqgJY4oiYlY5Ly
         rGAr7bTxKoHsHWpMn1ywRFYMlgP9P0T9XOuY9G1HTg9kzPqqc22FQaJm75jmZHdyx0uJ
         TswzpW8LkZfqjDZ8tQktEgIrm3GNlHvIll1kauC4uLzPdEcXh3+a0FMjmndjFkjnhJKI
         1y+g==
X-Gm-Message-State: AO0yUKUVBfGzdvQSCW3a4teEyUH3haFqXOoI7tU/2UXapG+DZca6Ljji
        MXXlCQVCk6KlB3RC93czJIx8vA==
X-Google-Smtp-Source: AK7set/FcralRRvQ4CXYApTqTnqbj2ZNBZa59S+VyuM/a2DYzDNurSHKd6YqK2cbPEwg7zdsDE8OqA==
X-Received: by 2002:adf:e0c6:0:b0:2c3:f026:9085 with SMTP id m6-20020adfe0c6000000b002c3f0269085mr11076691wri.13.1675955760173;
        Thu, 09 Feb 2023 07:16:00 -0800 (PST)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id d1-20020adffd81000000b002bfe08c566fsm1430295wrr.106.2023.02.09.07.15.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Feb 2023 07:15:59 -0800 (PST)
Date:   Thu, 9 Feb 2023 16:15:58 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Yinjun Zhang <yinjun.zhang@corigine.com>
Cc:     Saeed Mahameed <saeed@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Simon Horman <simon.horman@corigine.com>,
        Leon Romanovsky <leon@kernel.org>,
        David Miller <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Michael Chan <michael.chan@broadcom.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Gal Pressman <gal@nvidia.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Edward Cree <ecree.xilinx@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>, Fei Qin <fei.qin@corigine.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        oss-drivers <oss-drivers@corigine.com>
Subject: Re: [PATCH/RFC net-next 1/2] devlink: expose port function commands
 to assign VFs to multiple netdevs
Message-ID: <Y+UOLkAWD0yCJHCb@nanopsycho>
References: <20230206153603.2801791-2-simon.horman@corigine.com>
 <20230206184227.64d46170@kernel.org>
 <Y+OFspnA69XxCnpI@unreal>
 <Y+OJVW8f/vL9redb@corigine.com>
 <Y+ONTC6q0pqZl3/I@unreal>
 <Y+OP7rIQ+iB5NgUw@corigine.com>
 <Y+QWBFoz66KrsU7V@x130>
 <20230208153552.4be414f6@kernel.org>
 <Y+REcLbT6LYLJS7U@x130>
 <DM6PR13MB37055FC589B66F4F06EF264FFCD99@DM6PR13MB3705.namprd13.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DM6PR13MB37055FC589B66F4F06EF264FFCD99@DM6PR13MB3705.namprd13.prod.outlook.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, Feb 09, 2023 at 03:20:48AM CET, yinjun.zhang@corigine.com wrote:
>On Wed, 8 Feb 2023 16:55:12 -0800, Saeed Mahameed wrote:
>> On 08 Feb 15:35, Jakub Kicinski wrote:
>> >On Wed, 8 Feb 2023 13:37:08 -0800 Saeed Mahameed wrote:
>> >> I don't understand the difference between the two modes,
>> >> 1) "where VFs are associated with physical ports"
>> >> 2) "another mode where all VFs are associated with one physical port"
>> >>
>> >> anyway here how it works for ConnectX devices, and i think the model
>> should
>> >> be generalized to others as it simplifies the user life in my opinion.
>> >
>> >I'm guessing the version of the NFP Simon posted this for behaves
>> >much like CX3 / mlx4. One PF, multiple Ethernet ports.
>> 
>> Then the question is, can they do PF per port and avoid such complex APIs ?
>> 
>
>To answer your last question, it needs silicon support, so we can't for some old products.
>
>Then let me clarify something more for this patch-set's purpose. 
>Indeed, one port per PF is current mainstream. In this case, all the VFs created from PF0
>use physical port 0 as the uplink port(outlet to external world), and all the VFs from PF1
>use p1 as the uplink port. Let me call them two switch-sets. And they're isolated, you can't 
>make the traffic input from VFs of PF0 output to p1 or VFs of PF1, right? Even with TC in
>switchdev mode, the two switch-sets are still isolated, right? Correct me if I'm wrong here.
>And the posted configuration in this patch-set is useless in this case, it's for one PF with
>multi ports.
>
>Let me take NFP implementation for example here, all the VFs created from the single PF
>use p0 as the uplink port by default. In legacy mode, by no means we can choose other

Legacy is legacy. I believe it is like 5 years already no knobs for
legacy mode are accepted. You should not use it for new features.
Why this is any different?

Implement TC offloading and then you can ballance the hell out of the
thing :)


>ports as outlet. So what we're doing here is try to simulate one-port-per-PF case, to split
>one switch-set to several switch-sets with every physical port as the uplink port respectively,
>by grouping the VFs and assigning them to physical ports.
