Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D11BB6C2857
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 03:53:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229622AbjCUCxc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Mar 2023 22:53:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229511AbjCUCxb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Mar 2023 22:53:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12D7026599
        for <netdev@vger.kernel.org>; Mon, 20 Mar 2023 19:53:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A120461940
        for <netdev@vger.kernel.org>; Tue, 21 Mar 2023 02:53:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B263BC433D2;
        Tue, 21 Mar 2023 02:53:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679367210;
        bh=nyq+vGlKfSxwhEfMs686TA+eSZrAoYKY1Lgmc+oZYvE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=skx7LW728YXjOi0MYl322JySrALNuXQ0/DPR8/2o5SFtZNERih1Hw02Q6o4zHrzPp
         qTVnav+GN/eeBCXFoPt8YRw325WePHB3A3T9K2xdXUzK7Goopm9SV24PNmfBaZvRN1
         GeOnqDz/mLDw0ArCE5vBdkWwnY0aso3MAn7alivvzqKA31hbYyZD4bnwB1ShrdFg0/
         d2B3olOISc2WkZhkaXbXjZTD/f6/zPfdoQzf4T2FWYo4oaQOhsRMGN6qy5V8EfT8G8
         rOoyNbOL7Rwl4sgyPi+dmGNUlnU85eGDFCRB6mXKSehyyHffnSVKuhMO/VBWq/HXnQ
         mh5ii4RGH6Bvw==
Date:   Mon, 20 Mar 2023 19:53:28 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Davide Caratti <dcaratti@redhat.com>
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ilya Maximets <i.maximets@ovn.org>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 2/2] net/sched: act_tunnel_key: add support for
 "don't fragment"
Message-ID: <20230320195328.65f51b44@kernel.org>
In-Reply-To: <13672bdb258d2f261ef233033437f1034995785b.1679312049.git.dcaratti@redhat.com>
References: <cover.1679312049.git.dcaratti@redhat.com>
        <13672bdb258d2f261ef233033437f1034995785b.1679312049.git.dcaratti@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 20 Mar 2023 12:44:55 +0100 Davide Caratti wrote:
>  	TCA_TUNNEL_KEY_ENC_TOS,		/* u8 */
>  	TCA_TUNNEL_KEY_ENC_TTL,		/* u8 */
> +	TCA_TUNNEL_KEY_NO_FRAG,		/* u8 */

how about NLA_FLAG? u8 is the most wasteful of all attr types :(
