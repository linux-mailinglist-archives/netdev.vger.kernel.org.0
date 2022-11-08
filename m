Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E21D621124
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 13:43:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233903AbiKHMnZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 07:43:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233631AbiKHMnY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 07:43:24 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7E82116F
        for <netdev@vger.kernel.org>; Tue,  8 Nov 2022 04:43:23 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id m14-20020a17090a3f8e00b00212dab39bcdso17819089pjc.0
        for <netdev@vger.kernel.org>; Tue, 08 Nov 2022 04:43:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=sKudeoCrlAMCuwJypx7cVkyAuKvZkGTI/3BZq0KKlGU=;
        b=AQEN8jWMCvPNphq+37wlWqpDZKY0YaL8piwvj0NylExM5FDhKzFB9557mvT+0fDL+W
         O91GG1ma3kdi0tEbwn5p/bo0DBnqdetvSshFixZzkD8oGr6883xUQLGYlzs8f5qhlq54
         7H+opqM7wDaF3CdWZqGvQ05OF3aDwzN3lyZnpBhnljCDSbZ/UkJgBjH+QNEzlZO3KB1c
         sU8npKkcNtitHYYXHu/4TVBig0sHU2IKQEqDy28xNIvoQUOYtcb6PGzYA02V9iPCMpxF
         beEs+8Ay7gIeH4K2tkFnxBNu8HgMfBzRFkyeQmAsRAUTzIsMbe7R+uVzWDqh4ilX16J4
         LIjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sKudeoCrlAMCuwJypx7cVkyAuKvZkGTI/3BZq0KKlGU=;
        b=dV3WJ76Of8B0e7tjjL2JNJpw47qJAnqvNOnsYPMl0fOT+QMs+uKngE8fTuzjKwSHaZ
         Dpdeq/7EQSRqR+bZGMCedPbW39seZqKy5jt7a+9S+MWMRUBvxZoRzLYA8QmoMcVx62rH
         SXjEXjb6rH9b7n6Q3fupopzs5rrfgzgb//3/wxBp+W216ietTZRenu4iqCRm3ORTij0p
         h/lG6S0ANIJDbVZ6uOrTbbQQwc8VT0tgmIjkK9NukEJIi+vFVkm9vlKLBma7gEgUZl7X
         0/+x3d9bELN/Ogxt1E1up+XINKVBQ5XVzFcHxZLxKJYcNMHPgTlAQJ7NVv9YiWLA5/rI
         JJzA==
X-Gm-Message-State: ACrzQf1wl6DtCPyMPHh4IBv3m/bhRULVzCS56PXI1l2A8JmAv5lHxO+9
        +xJQyV0vDxKRCKLlcXb7wEWEXxAxe3Q=
X-Google-Smtp-Source: AMsMyM51DmXtI63gs5fkpXZf7UkDOWJwIjvziavB1u+CA1MDkc1lTVsnlnfN5ZydVqlN+QAvzGGRSg==
X-Received: by 2002:a17:902:ec86:b0:187:2430:d377 with SMTP id x6-20020a170902ec8600b001872430d377mr44859400plg.33.1667911403254;
        Tue, 08 Nov 2022 04:43:23 -0800 (PST)
Received: from Laptop-X1 ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id sj3-20020a17090b2d8300b0020ae09e9724sm5969738pjb.53.2022.11.08.04.43.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Nov 2022 04:43:22 -0800 (PST)
Date:   Tue, 8 Nov 2022 20:43:18 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, Guillaume Nault <gnault@redhat.com>,
        David Ahern <dsahern@kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>
Subject: Re: [PATCHv3 iproute2-next] rtnetlink: add new function
 rtnl_echo_talk()
Message-ID: <Y2pO5jXPgxJLIN9S@Laptop-X1>
References: <20220929081016.479323-1-liuhangbin@gmail.com>
 <Y2oWDRIIR6gjkM4a@shredder>
 <Y2ocsXykgqIHCcrF@Laptop-X1>
 <Y2oj9gNmsy0LhvjA@shredder>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y2oj9gNmsy0LhvjA@shredder>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 08, 2022 at 11:40:06AM +0200, Ido Schimmel wrote:
> > I can fix this either in iproute2 or in the selftests.
> > I'd perfer ask David's opinion.
> 
> Sure, but note that:
> 
> 1. Other than the 4 selftests that we know about and can easily patch,
> there might be a lot of other applications that invoke iproute2 and
> expect this return code. It is used by iproute2 since at least 2004.
> 
> 2. There is already precedence for restoring the original code. See
> commit d58ba4ba2a53 ("ip: return correct exit code on route failure").

OK, I will post a iproute fix first. If David or others has comments.
Please just NACK the new patch.

Thanks
Hangbin
