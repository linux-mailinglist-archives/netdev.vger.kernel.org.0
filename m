Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E13F94941DF
	for <lists+netdev@lfdr.de>; Wed, 19 Jan 2022 21:35:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232439AbiASUfK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jan 2022 15:35:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232109AbiASUfJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Jan 2022 15:35:09 -0500
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3D88C061574
        for <netdev@vger.kernel.org>; Wed, 19 Jan 2022 12:35:09 -0800 (PST)
Received: by mail-pl1-x62b.google.com with SMTP id u11so3276502plh.13
        for <netdev@vger.kernel.org>; Wed, 19 Jan 2022 12:35:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=dBnIWShS2XIeyvRHOI3i1y1DFwnj81mV1w4UHacPNS4=;
        b=bgIT6FI3KkRhmmj6FA9bGO1GL7s5Ay638eCexDbdZfUOpADZ/gbBroWST47UAOfqIL
         oKE32Z5a+MRbxj6olLJsN6ENOMad5z+JzEmUiNGnQb0jGGUjhXN9JLdiYvW5mxX2NEKf
         YW9tOZjqL4W2kL0zyNQPKZatWrgy+OkN9f3dSQF/CJnq6KDuBmKiwZcxwY6cj46idOTK
         7zZ6y7g+/l2VEzKqiEa9IC5SKDujtbcFznqMykizLL25XhzSlyI9m6KN4ftLmG+RigRE
         ImXOswdMsWzYw/SqJ1RFJE2maarxkO+4Tgn3UAjavWDm2yvE8nFMPo4lNBTdoTvrG1aF
         ciuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dBnIWShS2XIeyvRHOI3i1y1DFwnj81mV1w4UHacPNS4=;
        b=2VGjUvZq3VQJN4JiD7YUgFgN7N8l3nS+1beUTvHMFjFWC9nzbKbC42HXvzNAYUqC1q
         bejfUnf3CmwANXtVve3LCbXYDZ4GVgvjn4z3fF9B5XsH/6sVeelTETRoo81lvybXz0Gi
         QSO2xDJKBF25nCQkh9Uv2WBZbVko6bMggO0BCPJbX1BFgR3puegV7dbH8tZhhy4JMe9z
         EBCR6N8O39GLaX5NbplKDbRjz4eqnSG86l8BAqrQRpI4my0aXhRB+Ia6Kv453fiXu+L9
         QWsYVmWfAgDAMY+5o3tb3Y0c5lQnI42caUSQVFr/iZg8gxKigrxTJ8bFTGQ+BT2G2ZQ6
         tspQ==
X-Gm-Message-State: AOAM530ajfMrCeGrsUAz0MCMNODTZCdsPvAK059f+ii4rwdgTIY4iB8X
        qHMYxkUldEEteR5eUm4t3V/18IIt/sHurw==
X-Google-Smtp-Source: ABdhPJw4888rZCFeR6gzAM+qyQt8QhW1j5XwLidsQoCgy+5gkm3p2tNA+h4NeHF/a5vJx/EAFZquDQ==
X-Received: by 2002:a17:903:1c4:b0:14a:555c:adc0 with SMTP id e4-20020a17090301c400b0014a555cadc0mr34160960plh.101.1642624509218;
        Wed, 19 Jan 2022 12:35:09 -0800 (PST)
Received: from hermes.local (204-195-112-199.wavecable.com. [204.195.112.199])
        by smtp.gmail.com with ESMTPSA id bf23sm199370pjb.52.2022.01.19.12.35.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Jan 2022 12:35:08 -0800 (PST)
Date:   Wed, 19 Jan 2022 12:35:06 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Petr Machata <petrm@nvidia.com>
Cc:     David Ahern <dsahern@gmail.com>, <netdev@vger.kernel.org>,
        Maksym Yaremchuk <maksymy@nvidia.com>
Subject: Re: [PATCH iproute2] dcb: app: Add missing "dcb app show dev X
 default-prio"
Message-ID: <20220119123506.2360b139@hermes.local>
In-Reply-To: <87pmooove2.fsf@nvidia.com>
References: <f6e07ca31e33a673f641c9282e81ee9c3be03d3c.1642505737.git.petrm@nvidia.com>
        <0758f5ce-2461-95c2-edc0-9a24e44671d3@gmail.com>
        <87pmooove2.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 19 Jan 2022 11:38:54 +0100
Petr Machata <petrm@nvidia.com> wrote:

> >
> > In general, we are not allowing more uses of matches(). I think this one
> > can be an exception for consistency with the other options, so really
> > just a heads up.  
> 
> The shortening that the matches() allows is very useful for typing. I do
> stuff like "ip l sh dev X up" and "ip a a dev X 192.0.2.1/28" all the
> time. I suppose there was a discussion about this, can you point me at
> the thread, or where & when approximately it took place so I can look it
> up?

The problem is that matches() doesn't handle conflicts well.
Using your example:
  ip l 
could match "ip link" or "ip l2tp" and the choice of "link" is only because
it was added first. This is bad UI, and creates tribal knowledge that makes
it harder for new users. Other utilities don't allow ambiguous matches.
