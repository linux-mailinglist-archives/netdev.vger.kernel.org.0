Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 651CA5155FF
	for <lists+netdev@lfdr.de>; Fri, 29 Apr 2022 22:44:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239594AbiD2Urh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Apr 2022 16:47:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237448AbiD2Urh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Apr 2022 16:47:37 -0400
Received: from alexa-out-sd-01.qualcomm.com (alexa-out-sd-01.qualcomm.com [199.106.114.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46A4083B0E
        for <netdev@vger.kernel.org>; Fri, 29 Apr 2022 13:44:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=quicinc.com; i=@quicinc.com; q=dns/txt; s=qcdkim;
  t=1651265058; x=1682801058;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=irlHUzBA8ThhmxeBElihhTUew/GAY1k9ce5xvINl3P0=;
  b=woaop22/hliy0N5peuKR1QDgAQGeTpbjt8QY8Kp3M9Mrrf8G91sJ2ScM
   o0MdhjpkHCb6RQ7x7rLKXViirD7OL4QJHpPF9G07mCLnsQDWw+rfofgPy
   zeNsdphIrBqRCyElS1urAB9ouvvtOBGOtziLG5KtUXOlGIhwo6rFNOgxX
   M=;
Received: from unknown (HELO ironmsg-SD-alpha.qualcomm.com) ([10.53.140.30])
  by alexa-out-sd-01.qualcomm.com with ESMTP; 29 Apr 2022 13:44:18 -0700
X-QCInternal: smtphost
Received: from nasanex01c.na.qualcomm.com ([10.47.97.222])
  by ironmsg-SD-alpha.qualcomm.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Apr 2022 13:44:17 -0700
Received: from nalasex01a.na.qualcomm.com (10.47.209.196) by
 nasanex01c.na.qualcomm.com (10.47.97.222) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.22; Fri, 29 Apr 2022 13:44:17 -0700
Received: from qian (10.80.80.8) by nalasex01a.na.qualcomm.com (10.47.209.196)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Fri, 29 Apr
 2022 13:44:16 -0700
Date:   Fri, 29 Apr 2022 16:44:13 -0400
From:   Qian Cai <quic_qiancai@quicinc.com>
To:     Eric Dumazet <edumazet@google.com>
CC:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH v2 net-next] net: generalize skb freeing deferral to
 per-cpu lists
Message-ID: <20220429204413.GA438@qian>
References: <20220422201237.416238-1-eric.dumazet@gmail.com>
 <20220429161810.GA175@qian>
 <CANn89iLNpxXJMyDM-xLE_=N5jZ4jw6tfu+U++LSduUmnX7UE+g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CANn89iLNpxXJMyDM-xLE_=N5jZ4jw6tfu+U++LSduUmnX7UE+g@mail.gmail.com>
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01b.na.qualcomm.com (10.46.141.250) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 29, 2022 at 09:23:13AM -0700, Eric Dumazet wrote:
> Which tree are you using ?

linux-next tree, tag next-20220428

> Ido said the leak has been fixed in
> https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/commit/?id=f3412b3879b4f7c4313b186b03940d4791345534

Cool, next-20220429 is running fine so far which included the patch.
