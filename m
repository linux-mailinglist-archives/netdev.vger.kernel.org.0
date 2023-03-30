Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46A846CF96D
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 05:10:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229475AbjC3DKe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 23:10:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbjC3DKd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 23:10:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 370485240
        for <netdev@vger.kernel.org>; Wed, 29 Mar 2023 20:10:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BEC4561E99
        for <netdev@vger.kernel.org>; Thu, 30 Mar 2023 03:10:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C627FC433D2;
        Thu, 30 Mar 2023 03:10:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680145831;
        bh=uK0ycApV1wYfW8T9asbpjDQmawvkv+M2vzJ/re/gfuk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Vr/t6OLjiLbYIQmWNf13SqEI3Xu/DBbnXaqhXHJfOb/9K415lF7L7gBXe0H1JNlKi
         1BH7GEIfzZSlwVvv3kUFJe6tnVT0A9+teaXnDa0Pp4saxhfHjFONfPN74fhybK7e8V
         pFj1FN7YRa9N/VA6yK7S5YUxd1TRclR4vJ3zXqzA/GdjAWg+fZScLGf6F3/AWt81xh
         62jV8V0x+V9AOHXd6xkM4ldnLljTK7iIIGcFOLuD9yrCfkdXaVTIYblbtTAI/8DSNw
         OvFDCLpBczIyomr0lzgxP47+vvsO9avZJh77ikVz0152gr6/y4298tDBR4Q12tLQYX
         y53xE3ln9M/DQ==
Date:   Wed, 29 Mar 2023 20:10:29 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Yinjun Zhang <yinjun.zhang@corigine.com>
Cc:     Louis Peens <louis.peens@corigine.com>,
        David Miller <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Simon Horman <simon.horman@corigine.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        oss-drivers <oss-drivers@corigine.com>
Subject: Re: [PATCH net-next 1/2] nfp: initialize netdev's dev_port with
 correct id
Message-ID: <20230329201029.0fff8d9d@kernel.org>
In-Reply-To: <DM6PR13MB3705DBC0A077D7BC80929AA8FC8E9@DM6PR13MB3705.namprd13.prod.outlook.com>
References: <20230329144548.66708-1-louis.peens@corigine.com>
        <20230329144548.66708-2-louis.peens@corigine.com>
        <20230329122227.1d662169@kernel.org>
        <DM6PR13MB3705D6F71A159185171319E3FC8E9@DM6PR13MB3705.namprd13.prod.outlook.com>
        <20230329193831.2eb48e3c@kernel.org>
        <DM6PR13MB3705DBC0A077D7BC80929AA8FC8E9@DM6PR13MB3705.namprd13.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 30 Mar 2023 02:52:22 +0000 Yinjun Zhang wrote:
> > Yes, but phys_port_name is still there, and can be used, right?
> > So why add another attr?  
> 
> Yes, phys_port_name is still there. But some users prefer to use dev_port.
> I don't add this new attr, it's already existed since 
> 3f85944fe207 ("net: Add sysfs file for port number").
> I just make the attr's value correct.

You're using a different ID than phys_port_name, as far as I can tell :(
When the port is not split will id == label, always?
