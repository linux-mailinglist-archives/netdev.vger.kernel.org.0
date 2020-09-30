Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 165DF27F09A
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 19:34:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726335AbgI3ReL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 13:34:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725355AbgI3ReK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Sep 2020 13:34:10 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24EE5C061755
        for <netdev@vger.kernel.org>; Wed, 30 Sep 2020 10:34:09 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id q123so1673757pfb.0
        for <netdev@vger.kernel.org>; Wed, 30 Sep 2020 10:34:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=X8YhGkAs8SV1OiJtDSvGRFuvF8tscbDkooUH7id3H50=;
        b=P5uoL3Xj3uJoTyTXdIrmb6eRzuHMNLX4hpdpgs5birCv1DFPdqLVH3Z8tjx9L/uXse
         c/QnB8tjKYqi3UpKtFGmADQ6VOSPdaga7n/t4nrvN4m5iKIMsXSmsue5ehnX3afQTXU4
         5InOl7BBn9HsAPBzuv1UY9LhDS/8V0bjHWhAWQSSAkCf+0YdisEo7ZZe85OjV2cyU71Q
         7wpwU+Clq2R8/jm99vnw8sKWqHSvtqFi7ZBBvvoXXQYDe1jH/0sdgSFnK4aDZcF0ddS8
         ufj6D+MgndXbjQc+86wSaNX+UqXSzymN6vPv1tqSfloWZ0tFGfWbkC7PpnPzneI/foLg
         1xhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=X8YhGkAs8SV1OiJtDSvGRFuvF8tscbDkooUH7id3H50=;
        b=qliln94cpPJp77PBdrf36+QBI3I5dwoTrvcf4mpL+G7GCfw7E5bVcjhaU/gOPM5a3n
         XjZVjUjaEco17fcGu+bGLqmO8b7CDbNVMtlN5NiRTQ9CXiYL55o9gBrrr66IS3AH3dwS
         ktHuWLTAMLY1WZnHkUXoQZBqEe9ksYNCqs6t3hn7B87SRpjMEeadTBAXgloKBolxPPOY
         nhI1CGpQy0z0e/Q9xJ2EHI/7PU5hagjiV01n1N7+teAl9vSIKEqrcK31fQzVC5EB6KUn
         heMN+taKUOjmkW/Bz00PWtj+um2thiCFs19xI01bO6DDImq1n6pzRYcYHT6UoSIN64lF
         ZMZg==
X-Gm-Message-State: AOAM533jfsH8FzoU0o0wDQ6KsRz+ZMVfiuDinFMXz0wtC7cBvFx333rT
        Yho4xOAJ5NU+/OF3XWXdZI0JXQ==
X-Google-Smtp-Source: ABdhPJyJxNOcB4JGXKD7mLFOxVh5Tr/sb0STJaW7Q7rHP4G2fiwWVDtEh9xeVoQJ+CWTuNGOQYG7LQ==
X-Received: by 2002:a63:ce57:: with SMTP id r23mr2781337pgi.288.1601487248078;
        Wed, 30 Sep 2020 10:34:08 -0700 (PDT)
Received: from hermes.local (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id a1sm3145921pfr.12.2020.09.30.10.34.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Sep 2020 10:34:07 -0700 (PDT)
Date:   Wed, 30 Sep 2020 10:33:59 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     David Ahern <dsahern@gmail.com>
Cc:     Vlad Buslov <vladbu@nvidia.com>, netdev@vger.kernel.org,
        Vlad Buslov <vladbu@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>
Subject: Re: [RESEND PATCH iproute2-next 2/2] tc: implement support for
 terse dump
Message-ID: <20200930103359.1fa698fd@hermes.local>
In-Reply-To: <0d4e9eb2-ab6b-432c-9185-c93bbf927d1f@gmail.com>
References: <20200930073651.31247-1-vladbu@nvidia.com>
        <20200930073651.31247-3-vladbu@nvidia.com>
        <0d4e9eb2-ab6b-432c-9185-c93bbf927d1f@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 30 Sep 2020 08:57:20 -0700
David Ahern <dsahern@gmail.com> wrote:

> On 9/30/20 12:36 AM, Vlad Buslov wrote:
> > From: Vlad Buslov <vladbu@mellanox.com>
> > 
> > Implement support for classifier/action terse dump using new TCA_DUMP_FLAGS
> > tlv with only available flag value TCA_DUMP_FLAGS_TERSE. Set the flag when
> > user requested it with following example CLI:
> >   
> >> tc -s filter show terse dev ens1f0 ingress  
> 
> this should be consistent with ip command which has -br for 'brief'
> output. so this should be
> 
>    tc -s -br filter show dev ens1f0 ingress
> 
> Other tc maintainers should weigh in on what data should be presented
> for this mode.

Current ip brief mode is good, one line per interface. Something similar with tc
would be best.
