Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8353B60E91B
	for <lists+netdev@lfdr.de>; Wed, 26 Oct 2022 21:40:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234927AbiJZTka (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Oct 2022 15:40:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233563AbiJZTk2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Oct 2022 15:40:28 -0400
Received: from mail-lj1-x22c.google.com (mail-lj1-x22c.google.com [IPv6:2a00:1450:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6994F2EF5A;
        Wed, 26 Oct 2022 12:40:25 -0700 (PDT)
Received: by mail-lj1-x22c.google.com with SMTP id b18so23681819ljr.13;
        Wed, 26 Oct 2022 12:40:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dPVb88y4xWxYfjGTde6zJkh3P40sPGSgdB6pg2a7hRo=;
        b=fMWDjgDuFOiPoxHNLIxT6osZUXbZ4vLEWRZwOMWXyEc8dsjlTemSTN4FhK37fRWm/r
         wIZWRNGp0E2r2oPkqwMS+VDyEGMFjguWJgamygwoFtQTnu4gaXUAFeaBbP9lJd4WoW83
         ZIdjwp8cS2VbKs04FNnxUwLJ//3GoI+vOU35NGW0jH1OOWX9noqEdEQHntR8ZmVPv3Nj
         8/MJuyLf0lkfkgArF0aWzKwgunrH0Rx4bHtBCRruliGqpujCsCFNNz2WHB+kBT9Qrheo
         APj62yqr/lCNWn3EPBi/fgcNc2R1RvG8cZOp7TeErbDolhnHBE+7J4EAh+ORsa2gdMVz
         Wdug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dPVb88y4xWxYfjGTde6zJkh3P40sPGSgdB6pg2a7hRo=;
        b=HcjSd1Vx65khYgioZ00pA5gUySLCkVM8W6SUzbAZ+XtBQUmg2FHU5pYJCmSUr9zIVl
         NPhetOFy34PJZ1KxC+tLKut/bLY6aG7J0ioZkzJrMr0LiBJpMNlmrlpmB3xLsb4JD+Wy
         JtP20qVEysIQnc1/gAOzozGy3KGxtjVCtvgEPpa+PrdXJSGbWiA7wAnF3HztH8WieRac
         DLtx6qI6PU4QcnrXs5SvBD1FgZkmaHqgVLt97zNIBxjCH8MVbFWOHDSmrfRvtv9vauAD
         go9F+FmpFL5c8Khau+ew3TBQEhnWdzy+mZpAIaCirsILxCqdB6Dq5KbNSEOO59BcjYBg
         hoJw==
X-Gm-Message-State: ACrzQf3li+tmuV9uhkzCawtRY8HDJHb7lhR0kLp7RDPRviKOM5eEErMn
        zFR9sFophoKpUIDZDxXFvXS2d7dA28UVxQ==
X-Google-Smtp-Source: AMsMyM4QvKXjN8X4/dE/LQGxCciJeevRuDd4zp/3po7hQ2/xMUzwCSPFrHXAsehiVqc5EAH5wH8r1Q==
X-Received: by 2002:a2e:be10:0:b0:26f:b35e:c29e with SMTP id z16-20020a2ebe10000000b0026fb35ec29emr17854751ljq.488.1666813223901;
        Wed, 26 Oct 2022 12:40:23 -0700 (PDT)
Received: from smtpclient.apple (188-177-109-202-dynamic.dk.customer.tdc.net. [188.177.109.202])
        by smtp.gmail.com with ESMTPSA id i14-20020a0565123e0e00b0048a921664e8sm947779lfv.37.2022.10.26.12.40.22
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 26 Oct 2022 12:40:23 -0700 (PDT)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3731.200.110.1.12\))
Subject: Re: [PATCH] Periodically flow expire from flow offload tables
From:   Michael Lilja <michael.lilja@gmail.com>
In-Reply-To: <25246B91-B5BE-43CA-9D98-67950F17F0A1@gmail.com>
Date:   Wed, 26 Oct 2022 21:40:11 +0200
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>, netdev@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <03E5D5FA-5A0D-4E5A-BA32-3FE51764C02E@gmail.com>
References: <20221023171658.69761-1-michael.lilja@gmail.com>
 <Y1fC5K0EalIYuB7Y@salvia> <381FF5B6-4FEF-45E9-92D6-6FE927A5CC2D@gmail.com>
 <Y1fd+DEPZ8xM2x5B@salvia> <F754AC3A-D89A-4CF7-97AE-CA59B18A758E@gmail.com>
 <Y1kQ9FhrwxCKIdoe@salvia> <25246B91-B5BE-43CA-9D98-67950F17F0A1@gmail.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
X-Mailer: Apple Mail (2.3731.200.110.1.12)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

I just quickly tried following the flow_offload_teardown() path instead =
of clearing IPS_OFFLOAD in flow_offload_del() and it does have some side =
effects. The flow is added again before the HW has actually reported it =
to be NF_FLOW_HW_DEAD.=20

The sequence with my patch is:
  : Retire -> Remove from hw tables -> Remove from sw tables -> =
kfree(flow) -> flow_offload_add()

But if flow_offload_teardown() is called on expire I see:
  : Retire -> Remove from hw tables -> flow_offload_add() -> Remove from =
sw tables -> kfree(flow)
=20
I need to investigate why this happens, maybe the IPS_OFFLOAD flag is =
cleared too early and should not be cleared until the flow is actually =
removed, like I do? Maybe the issue is not seen before because on =
timeout or flow_is_dying() no packet arrive to create the flow again =
prematurely?

Thanks,
Michael

