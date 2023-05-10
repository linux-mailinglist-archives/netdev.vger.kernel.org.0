Return-Path: <netdev+bounces-1299-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D29526FD38E
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 03:30:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6C275280FC5
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 01:30:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 42478388;
	Wed, 10 May 2023 01:30:31 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30A2F362
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 01:30:31 +0000 (UTC)
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1591D30DA
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 18:30:30 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-559de0d40b1so110142927b3.0
        for <netdev@vger.kernel.org>; Tue, 09 May 2023 18:30:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1683682229; x=1686274229;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=A3qJt0oqHSEE/9USCwELe+Q7JVs8UGGcYvtBtMe/lLg=;
        b=VUM187cu+hcTmudeHOcMNDcyds8HKqz7++whdmcUf1YZ7p4HyF/Q8lcLj2ZOmppvrw
         y+YT5dPi4DuZDsqpql2F5w/iiA/zaLrPUlhuwt98R5/wvQ3eFUeA+oT2efVL7ariRiMm
         9oHov+PPVD2kKpNW8pgVsRlgUkYBELykMl7pFsDllCS4JgpXV2C4gm9yRzObZ8PSidCZ
         WOsjdbt+wkoC2iDGd0p45pV4oUSPevBtHHZODHKL39+nmc2LW48lBH0HS2IGESzMzF3v
         fm7g01MI5ZK+nJff+TIUhripxWqZzl78w09sGf5Mr8NXhvS3QbwxB8ixvkKp//ejDGq9
         KObQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683682229; x=1686274229;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=A3qJt0oqHSEE/9USCwELe+Q7JVs8UGGcYvtBtMe/lLg=;
        b=QY4RL20IkgadjwOLqfBPaBNMBqe+Gc0u/2m70urr3ZWO822kGO+Ku4EBKOC1i39ouj
         XMgh7R63bcUu/WwdxdQ+lSu2azZE80cFbH2qeE63d00cObgpzBONgzOApcukNe0yZ8UP
         2THL7VWUbVYnFKnmQ3Mw3KbaZvJHG3hKBzBoYwjoCHhIO40mo+Pix683ZFyUKeeByv+l
         HffJ8LBkcJVx6FqKNIrJrd4Yscja3r5SrcqlfIn6DfSggdOfZMw71tfWDKc33jfpeqKP
         RbcKD8L4ciRTEEqMO0WoCS8jEaSn3UmwcJkC7G9ezlG1HGYmNtJDOBrXv5HOuFz1LQq+
         HIPg==
X-Gm-Message-State: AC+VfDybnDz9+UYHXIFbdEXcWjnODe5NaPBwI6WlXHfb0vSMcGrTSEen
	rpELVDrFwU3IBgv0erINv8phCzt6Pz4KlUsjiSAz8aMOwB64XHTHkDIJayEisKy3NPX/D33TDVw
	9JIDL2qIobki6pv1W+ggJJ9orB7d4p0cyLx1rMNkbiPJfiRUfUgnPXW5VMdErarIlD/UjcN2Yqn
	LQeA==
X-Google-Smtp-Source: ACHHUZ74n7W9nvoy4/+OcWmHd9hijOyCfhzfisJq4kLsX9N/npeZ8VGuSd/y+7lM97BHPkVrpm/hymrHOvhqtzDRqw0=
X-Received: from obsessiveorange-c2.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1b95])
 (user=benedictwong job=sendgmr) by 2002:a81:4513:0:b0:55d:f929:418f with SMTP
 id s19-20020a814513000000b0055df929418fmr5405593ywa.1.1683682229259; Tue, 09
 May 2023 18:30:29 -0700 (PDT)
Date: Wed, 10 May 2023 01:30:20 +0000
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.40.1.521.gf1e218fcd8-goog
Message-ID: <20230510013022.2602474-1-benedictwong@google.com>
Subject: Re-adding support for nested IPsec tunnels
From: Benedict Wong <benedictwong@google.com>
To: netdev@vger.kernel.org, steffen.klassert@secunet.com, 
	martin@strongswan.org
Cc: nharold@google.com, benedictwong@google.com, evitayan@google.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

This patch set adds support for inbound nested IPsec tunnels within the 
same network namespace by incrementally marking verified secpath entries 
once policy checks are complete. This allows verification that each layer 
of nested tunnels can be verified, even where the outermost headers 
change (src/dst/proto/etc). 

The previous iteration b0355dbbf13c ("Fix XFRM-I support for nested ESP 
tunnels") attempted to clear secpath entries once verified, but that 
caused issues with netfilter policy matching (lack of secpath entries to 
match against), and transport-in-tunnel mode (where the tunnel policies 
are still resolvable, and thus expected). 

Notably, all secpath entries (except where optional) must still have the 
secpath entries validated, but they may now happen in multiple steps.



