Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C145605232
	for <lists+netdev@lfdr.de>; Wed, 19 Oct 2022 23:46:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230056AbiJSVqj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Oct 2022 17:46:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230101AbiJSVqg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Oct 2022 17:46:36 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBA9C386AC
        for <netdev@vger.kernel.org>; Wed, 19 Oct 2022 14:46:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8C5D3B825A8
        for <netdev@vger.kernel.org>; Wed, 19 Oct 2022 21:46:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2CFEC433C1;
        Wed, 19 Oct 2022 21:46:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666215992;
        bh=dWjrxJLv6EtFh0OtSSAwYG/m9iFjw6TJ14dnM5oeGMo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=NP+lV/8DLR+2q4H9RAhZzEgCGiGZK8sP9hEa8ZfanVRQXqLzzf9SOvTLRuuhrQwNj
         NxOszmTC50UiTXeWBt1Mzl1feLuIPNfTa2YPcoGmAFCwDF9cXgVFTh7kKE5dxH4QRV
         Yd0a/hZXnX0hddGlGkNDgitlEPrpBR6+R6tnPESUzjvPIi79zWbHcbWiE+d7dhN5Fw
         75fnPcE4g/rhCFowdhzr7W1OXYLVYYmmDQ6hNcjFHVPqErE9xEcd8S8Gh1I2IdYmoY
         zFdhTYR4voDEqvwy1YJtHRZW77Fh1/77IjhgzC6rnYhydQJBJUyHTaAPswlZv7DLyE
         1RWpWqI0KRjFQ==
Date:   Wed, 19 Oct 2022 14:46:30 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     <davem@davemloft.net>, <johannes@sipsolutions.net>,
        <netdev@vger.kernel.org>, <edumazet@google.com>,
        <pabeni@redhat.com>, <jiri@resnulli.us>, <razor@blackwall.org>,
        <nicolas.dichtel@6wind.com>, <gnault@redhat.com>, <fw@strlen.de>
Subject: Re: [PATCH net-next 07/13] genetlink: support split policies in
 ctrl_dumppolicy_put_op()
Message-ID: <20221019144630.6c71aa5a@kernel.org>
In-Reply-To: <7539c7f0-503b-57c6-9eda-1eb543b8587e@intel.com>
References: <20221018230728.1039524-1-kuba@kernel.org>
        <20221018230728.1039524-8-kuba@kernel.org>
        <7539c7f0-503b-57c6-9eda-1eb543b8587e@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 19 Oct 2022 14:38:41 -0700 Jacob Keller wrote:
> > +	if (!doit->policy && !dumpit->policy)
> >  		return 0;
> >    
> 
> We don't need to check the GENL_DONT_VALIDATE_DUMP because the previous
> code for getting the split op checked this and set some other fields, right?

Yes - let me amend the commit message.
