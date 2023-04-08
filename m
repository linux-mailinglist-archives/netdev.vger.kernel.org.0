Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3987D6DBB3F
	for <lists+netdev@lfdr.de>; Sat,  8 Apr 2023 15:48:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229683AbjDHNs1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Apr 2023 09:48:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229485AbjDHNs0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Apr 2023 09:48:26 -0400
Received: from mail-yw1-x112c.google.com (mail-yw1-x112c.google.com [IPv6:2607:f8b0:4864:20::112c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 615BD1BC6
        for <netdev@vger.kernel.org>; Sat,  8 Apr 2023 06:48:25 -0700 (PDT)
Received: by mail-yw1-x112c.google.com with SMTP id 00721157ae682-54ee108142eso25898767b3.2
        for <netdev@vger.kernel.org>; Sat, 08 Apr 2023 06:48:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112; t=1680961704; x=1683553704;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6rqMgQTR8mOnwdweIlfI893LRK7Zh78hvAwoq6si8LE=;
        b=asTzt1Wh7rs2CmWJaSFZVOEn/sGHYF5OB3wBPZ4DdxAEaHHTX5S2jF79xv7IUo4cEq
         Igcv+j+XjCQopG+flUIYpFiTU8Hjg5iztB7dmkayo3/MJES7RqxYHixlRT6qmmLh7bvO
         6oQg1mA6tvrxwwkwXZ6IbpR84DXxnA7hfHymYknFFgamm82zi0tW3MYu2MnQ8T0H/SpR
         SCMdrDP5SwyOC8eYmekI1oIdlSw9pBwv37rfLfjIozlRmbSt0a2J/A5AXSU6R2JciYeE
         9xoWAPqoSxVVCOexO06FKiUqV2h1yjoTnzsO317rP5j9Zyg4losN/InxMbIgqBBgwUEj
         /9Xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680961704; x=1683553704;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6rqMgQTR8mOnwdweIlfI893LRK7Zh78hvAwoq6si8LE=;
        b=fFSzVysjHvbGNBXRHEppWXIb5LsiIQvkckf7YghXnwP+5CC2nbbGu31aWV/NAEBdsT
         3xVQZDaI7luJDTYSVMsQxXN2xvDbEL4FCZXYg2EJB5DXMwmi+ZkjJv6ZnPFZ7pVeiZ4s
         LNUYzHYvAMNDNSxKGLE3e+nsb5i3E/gYHglUTfQp9m2/cMYLmNC7Ri+ymp7bVG2wSY8S
         z9vikD9ywjDqINAWcZaGOzsMg3buAOCEwwZz1z0/f/Ks7P0iZZH8eJ8j8kAGi0Q+aOkL
         93dVOzhXfzzGBz2xleWUih+sRljajki7rghN/qrKaP2l4KGhOSSWR3X7HtgUSGu1x8pE
         MSUw==
X-Gm-Message-State: AAQBX9fm4gWNthzOBATkoT1JX5BbNMO0KFopSjeLun9KWxNE+G2fL120
        gpMLIX0XFK/0Q15KFC2EucBCBnOBrv7iVn7DyXqOHVHUAGFJUAdv
X-Google-Smtp-Source: AKy350Yu49+SYUHGcyY+m6ZGRVGqxaSb/AWD56dcVSR97DgnWRzS9RfDa1rLnDJo0UKv+zSyk7UTwZx9gDLPRszT0Hs=
X-Received: by 2002:a81:c145:0:b0:545:1d7f:abfe with SMTP id
 e5-20020a81c145000000b005451d7fabfemr2821801ywl.7.1680961703923; Sat, 08 Apr
 2023 06:48:23 -0700 (PDT)
MIME-Version: 1.0
References: CAM0EoMkvfUOubhgC+PpLi9vKcjsyc+Tp-uOuK60AJhaMaS2ogA@mail.gmail.com <365242745.7238033.1680940391036@mrd-tw.us-east-1.eo.internal>
In-Reply-To: <365242745.7238033.1680940391036@mrd-tw.us-east-1.eo.internal>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Date:   Sat, 8 Apr 2023 09:48:12 -0400
Message-ID: <CAM0EoMkuv=3C_jsn6NEsWoGBBzL2WDSNAOWxTfJ-Oh8xfJs1Fg@mail.gmail.com>
Subject: netdev email issues?
To:     Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Getting a lot of these...
Is there a way what email address is not valid?

cheers,
jamal

---------- Forwarded message ---------
From: Postmaster <postmaster@dopamine-today.bounceio.net>
Date: Sat, Apr 8, 2023 at 3:53=E2=80=AFAM
Subject: Undeliverable: Re: [PATCH v4 net-next 2/9] net/sched: mqprio:
simplify handling of nlattr portion of TCA_OPTIONS
To: <jhs@mojatatu.com>


MESSAGE NOT DELIVERED

There was an issue delivering your message to got@dopamine.today. This
is an 5.1.2 Error.

This error typically means: The domain name of the email address is not val=
id

Find out more information about this 5.1.2 bounce message.




---------- Forwarded message ----------
From: Jamal Hadi Salim <jhs@mojatatu.com>
To: Vladimir Oltean <vladimir.oltean@nxp.com>
Cc: netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
Paolo Abeni <pabeni@redhat.com>, Cong Wang <xiyou.wangcong@gmail.com>,
Jiri Pirko <jiri@resnulli.us>, Vinicius Costa Gomes
<vinicius.gomes@intel.com>, Kurt Kanzenbach <kurt@linutronix.de>,
Gerhard Engleder <gerhard@engleder-embedded.com>, Amritha Nambiar
<amritha.nambiar@intel.com>, Ferenc Fejes <ferenc.fejes@ericsson.com>,
Xiaoliang Yang <xiaoliang.yang_1@nxp.com>, Roger Quadros
<rogerq@kernel.org>, Pranavi Somisetty <pranavi.somisetty@amd.com>,
Harini Katakam <harini.katakam@amd.com>, Giuseppe Cavallaro
<peppe.cavallaro@st.com>, Alexandre Torgue
<alexandre.torgue@foss.st.com>, Michael Sit Wei Hong
<michael.wei.hong.sit@intel.com>, Mohammad Athari Bin Ismail
<mohammad.athari.ismail@intel.com>, Oleksij Rempel
<linux@rempel-privat.de>, Jacob Keller <jacob.e.keller@intel.com>,
linux-kernel@vger.kernel.org, Ferenc Fejes <fejes@inf.elte.hu>, Simon
Horman <simon.horman@corigine.com>
Bcc:
Date: Fri, 7 Apr 2023 12:05:35 -0400
Subject: Re: [PATCH v4 net-next 2/9] net/sched: mqprio: simplify
handling of nlattr portion of TCA_OPTIONS
Message truncated.
