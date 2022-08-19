Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 680D159A7EF
	for <lists+netdev@lfdr.de>; Fri, 19 Aug 2022 23:49:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238403AbiHSVp6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Aug 2022 17:45:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235003AbiHSVpu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Aug 2022 17:45:50 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 160EF10267A
        for <netdev@vger.kernel.org>; Fri, 19 Aug 2022 14:45:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6E96CB82963
        for <netdev@vger.kernel.org>; Fri, 19 Aug 2022 21:45:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEBF1C433D7;
        Fri, 19 Aug 2022 21:45:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660945547;
        bh=h9PszNsfyYoukS5yFrK8DpaXgQpEzY5bdo6rcREClk0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=BGaBjD2N47I+E5yCEQbdqZDbl9BfeVn/AJnZYCr9Ll/4dGxyDWKbohegMTkY7TxgE
         EnNWau2UlObPEpnxOt4lHEt7t7G8v7eiyRCCZo8Tz+mW+oDcqbCweD10nC/70iL5hm
         yFVUywT3xYwz6aYUmVFoTEmGC33f2ExY9vI2bYBhwym8/3tsLCp3i4S+q+j8pU2AXL
         UL2SHTgULAH1KDKpYaZBNaz+ztfbl6clU/TRvHRRUaoc4TUbrf49xALpq/JQW2iTim
         2j1JjfxCLyvZiYpcC4jcBTU/E1UfYqpLhQ5XV6ogGCPx+Od4XBEthe4ygXVnS7pQhS
         Zs0DTvdEqR8ew==
Date:   Fri, 19 Aug 2022 14:45:45 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Keller, Jacob E" <jacob.e.keller@intel.com>
Cc:     Jiri Pirko <jiri@resnulli.us>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "idosch@nvidia.com" <idosch@nvidia.com>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "saeedm@nvidia.com" <saeedm@nvidia.com>,
        "vikas.gupta@broadcom.com" <vikas.gupta@broadcom.com>,
        "gospo@broadcom.com" <gospo@broadcom.com>
Subject: Re: [patch net-next 4/4] net: devlink: expose default flash update
 target
Message-ID: <20220819144545.1efd6a04@kernel.org>
In-Reply-To: <CO1PR11MB50890139A9EEBD1AEBA54249D66C9@CO1PR11MB5089.namprd11.prod.outlook.com>
References: <20220818130042.535762-1-jiri@resnulli.us>
        <20220818130042.535762-5-jiri@resnulli.us>
        <20220818195301.27e76539@kernel.org>
        <CO1PR11MB50890139A9EEBD1AEBA54249D66C9@CO1PR11MB5089.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 19 Aug 2022 20:59:28 +0000 Keller, Jacob E wrote:
> > My intuition would be that if you specify no component you're flashing
> > the entire device. Is that insufficient? Can you explain the use case?
> > 
> > Also Documentation/ needs to be updated.  
> 
> Some of the components in ice include the DDP which has an info
> version, but which is not part of the flash but is loaded by the
> driver during initialization.

Right "entire device" as in "everything in 'stored'". Runtime loaded
stuff should not be listed in "stored" and therefore not be considered
"flashable". Correct?
