Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22E465A9B21
	for <lists+netdev@lfdr.de>; Thu,  1 Sep 2022 17:04:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234593AbiIAPD4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Sep 2022 11:03:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234227AbiIAPDz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Sep 2022 11:03:55 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACF9083BE5;
        Thu,  1 Sep 2022 08:03:53 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id s11so22930722edd.13;
        Thu, 01 Sep 2022 08:03:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date;
        bh=vcK8Y9RIhCFnLAHNF1ma+eBloNnCb12iQrkaA2RWwss=;
        b=CLVGkKkq/LgD+cnFQOBUzqNyMDKzqCmneML9igIGH21aL1qaB01IR1MGTfUeaE+mkC
         P0Bqs5Hm2jJX4LghL1s25mvHgPqhSusaATiSomUqcmb5pyZ+Ut59gpyDQvfGacFJokdx
         zL46/UrTEHe1u6MiaxkzdjZZFP8bN24zSYxvcOVV+sEpteyIik5m4Ot6jLpL4O1xS1Ci
         3LHN0Xuchj4i1ranV/AIN7UQR9JYaovQJ903/yHm3bEVhAwtc73gMdwiTWTITKWITJBZ
         clsHHPSng+BYK9GNC4JOrZb96p4jjl8m0+6QRH/+Pl4m16Qde9xKgZOqn9abEW6UOcYq
         Hk7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date;
        bh=vcK8Y9RIhCFnLAHNF1ma+eBloNnCb12iQrkaA2RWwss=;
        b=Q5tM1knmNpefvTpECdUpQZ14L7p4R/sGEjFsLo56ojjAmCmCJKhg+WBMiPCHoDuO2I
         a6zFGKyq9wr+c7Af+pP7uDgf8LzHH8UJ5JwLzMgUspWfowm20Lzc4JCh3Go7Dcwouh/H
         Yr0WFl+WjZrcfYECBgQQhmGkURG4yQlV/WECuoTNjSWgNrTnMalMC1AIMrBnsWSaTxyn
         jwDi77CbD0ayvqKHQfOpD7J9ozAxiUNQGl/0F4Mr3caHyvWpzA4c198n/rl36efi1kNS
         phfqxUPxPlqgvrUKsdJ7Mxy2XZTUpkC+98iBBYBYdsRtTGsNDtXSFdNtVSXl75Uqw/nP
         FxZQ==
X-Gm-Message-State: ACgBeo2vQDtRkoBqvrow7sT/7VQHJY1orR8MU3hUg4zMBSZ14W7KtXm+
        /AVBJxtCAsMG+V29hLv4ePE=
X-Google-Smtp-Source: AA6agR6ecAmWtCB5BI8iMnmqsmfam7Lue/g0foYnFCgWMZksqtn0CBXZVzGuccTxeDYuPlKSHE2oAg==
X-Received: by 2002:a05:6402:268b:b0:446:381d:7b45 with SMTP id w11-20020a056402268b00b00446381d7b45mr29179355edd.372.1662044632304;
        Thu, 01 Sep 2022 08:03:52 -0700 (PDT)
Received: from debian ([89.238.191.199])
        by smtp.gmail.com with ESMTPSA id o18-20020a170906601200b007314a01766asm8545273ejj.211.2022.09.01.08.02.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Sep 2022 08:03:51 -0700 (PDT)
Date:   Thu, 1 Sep 2022 17:01:18 +0200
From:   Richard Gobert <richardbgobert@gmail.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Martin KaFai Lau <kafai@fb.com>,
        netdev <netdev@vger.kernel.org>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-wpan@vger.kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org
Subject: Re: [PATCH 3/4] net-next: frags: add inetpeer frag_mem tracking
Message-ID: <20220901150115.GB31767@debian>
References: <20220829114648.GA2409@debian>
 <CANn89iLkfMUK8n5w00naST9J+KrLaAqqg2r0X9Sd-L0XzpLzSQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANn89iLkfMUK8n5w00naST9J+KrLaAqqg2r0X9Sd-L0XzpLzSQ@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 29, 2022 at 03:15:47PM -0700, Eric Dumazet wrote:
> We tried to get rid of any dependence over inetpeer, which is not
> resistant against DDOS attacks.
> 
> So I would not add a new dependency.

I see your point. What do you suggest doing differently?

The inetpeer mechanism is used for IPv4 frags. If it isn't resistant
against DDoS attacks, can it perhaps be improved?
