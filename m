Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 450835E72BF
	for <lists+netdev@lfdr.de>; Fri, 23 Sep 2022 06:16:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229942AbiIWEPd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Sep 2022 00:15:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229647AbiIWEPc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Sep 2022 00:15:32 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45205E4DA7
        for <netdev@vger.kernel.org>; Thu, 22 Sep 2022 21:15:31 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id u132so11257511pfc.6
        for <netdev@vger.kernel.org>; Thu, 22 Sep 2022 21:15:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=FoDQYzfM5O8q57KWKIF7FQAKxKyc2tuMIBq3K2/Ru3A=;
        b=RHDI6/pOjWYrDoZXgrAcfJzTLf+nHTTnw1de3lQj1+n3yWKNoxxR3irIvVweLMTkG0
         dlMbae8BXWbvs3WJk1gEPUca5+zKc+Y9ZLZ5F+gZsi87xIPUAXzLcCv+f2mK680pwjpi
         riC7DFWmJV+FYV+XRY8+aXerFwLdpItzNKljhY6hohpJFdBpV4KD0C0RC2Amhe97zrDa
         e7f2Fj4HtypWYKBUfqMHqTz7yfMhXa1dn+G2TyBCj5HAuvcnwSSshfKgFFItv4A287UA
         pnxYKk3ztJMg0g6kUL4SdXc4n3Kw3GDCE9k0BXll8y8KO10saOPBkwxvVhjAFdXSfnAq
         WqXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=FoDQYzfM5O8q57KWKIF7FQAKxKyc2tuMIBq3K2/Ru3A=;
        b=sTWO0/JwCrtVZczhxQb0/FLiWY1CYzpm1j93mFt1WVk4rQ5VEbMv1PhooBYdA8pggX
         te6JmWBIwdfTtctUIyOOF0KmjPgZtpCj42ihwZD2cRsrzIjIyQuy5cQyWJvfnoo641NF
         KBhV3x0LKO/+qIltRf89BQUVj5+wLo/BHy5MZV6xM0/0Kg+xG/tNZJ5EWAUHrWkqYYH4
         iNTb8HEBlqdvh95bH92xDzNjFTx1dwP1qqLr/dFT8CwGil9MQKudb/qZKEUrlx1LxiID
         FYGhvLwsP9wfPE9y3vAKdGlM7/cIYaoX19I+C7St+NGfeS3Cw/bKqxeQ++op6fYThRGT
         GPMQ==
X-Gm-Message-State: ACrzQf1b1hTVKU5RFLGdOIkqydcLdXwRX4a1iNCEOkKPfNOX+az6tiGT
        65M96W0n7wSkPilZbt1Klr8=
X-Google-Smtp-Source: AMsMyM7db6F7aCsKH7oCeLIpA2fOEoxWci+wMbbj2Jh7hc/HqnTo9KzOi5etLuCxUOtyZghu7qCvig==
X-Received: by 2002:a65:464a:0:b0:434:883:ea21 with SMTP id k10-20020a65464a000000b004340883ea21mr6219224pgr.152.1663906530721;
        Thu, 22 Sep 2022 21:15:30 -0700 (PDT)
Received: from Laptop-X1 ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id q12-20020a170902dacc00b0016c50179b1esm4979211plx.152.2022.09.22.21.15.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Sep 2022 21:15:30 -0700 (PDT)
Date:   Fri, 23 Sep 2022 12:15:26 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     David Ahern <dsahern@kernel.org>
Cc:     netdev@vger.kernel.org,
        Stephen Hemminger <stephen@networkplumber.org>,
        Guillaume Nault <gnault@redhat.com>
Subject: Re: [PATCH iproute2-next 1/1] ip: add NLM_F_ECHO support
Message-ID: <Yy0y3qIS1rLGt3s1@Laptop-X1>
References: <20220916033428.400131-1-liuhangbin@gmail.com>
 <20220916033428.400131-2-liuhangbin@gmail.com>
 <fba2ec25-d15c-8c1a-32f8-d20d81c1f1cb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fba2ec25-d15c-8c1a-32f8-d20d81c1f1cb@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 22, 2022 at 04:17:08PM -0700, David Ahern wrote:
> > +	if (echo_request)
> > +		req.n.nlmsg_flags |= NLM_F_ECHO|NLM_F_ACK;
> 
> fixed the spacing on the flags (all locations) and applied to iproute2-next.

Thanks for the fixing!
> >  
> > +	if (echo_request) {
> > +		new_json_obj(json);
> > +		open_json_object(NULL);
> > +		print_addrinfo(answer, stdout);
> > +		close_json_object();
> > +		delete_json_obj();
> > +		free(answer);
> > +	}
> 
> That list is redundant. I think it can be turned into a util function
> that takes an the print function as an input argument.

I will post a patch to remove the redundant code.

Hangbin
