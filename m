Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CE145ADFA2
	for <lists+netdev@lfdr.de>; Tue,  6 Sep 2022 08:17:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238610AbiIFGRa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Sep 2022 02:17:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238527AbiIFGQ6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Sep 2022 02:16:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A545C71BEC
        for <netdev@vger.kernel.org>; Mon,  5 Sep 2022 23:15:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E01B4612DB
        for <netdev@vger.kernel.org>; Tue,  6 Sep 2022 06:15:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAAA5C433C1;
        Tue,  6 Sep 2022 06:15:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662444940;
        bh=hRQGhz4mWavoL/4X/r0gw+F2RXcmlGKJ+IPeHA/W3hA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mcpHjePk7Ue0pDaP7qhez1VdXUfSbCkjGUdFb45EC3BvPAVRfxomMiyByqZnVlyHP
         xpye0YYSCierCSn84BLvSXhklceLbfAUqlcSOEKAYtDYl+GvFIcNmCWOVb4Ebi/npW
         LsxjFtjcQ+RHIYvL5C7C1q14EQvrXFnPhkIBGPnY=
Date:   Tue, 6 Sep 2022 08:15:36 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     "Michalik, Michal" <michal.michalik@intel.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>,
        "G, GurucharanX" <gurucharanx.g@intel.com>,
        Jiri Slaby <jirislaby@kernel.org>,
        Johan Hovold <johan@kernel.org>
Subject: Re: [PATCH net 3/3] ice: Add set_termios tty operations handle to
 GNSS
Message-ID: <YxbliLlS9YU6eKMn@kroah.com>
References: <20220829220049.333434-1-anthony.l.nguyen@intel.com>
 <20220829220049.333434-4-anthony.l.nguyen@intel.com>
 <20220831145439.2f268c34@kernel.org>
 <YxBHL6YzF2dAWf3q@kroah.com>
 <BN6PR11MB417756CED7AE9DF7C3FA88DCE37F9@BN6PR11MB4177.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN6PR11MB417756CED7AE9DF7C3FA88DCE37F9@BN6PR11MB4177.namprd11.prod.outlook.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 05, 2022 at 07:32:44PM +0000, Michalik, Michal wrote:
> Hello Greg,
> 
> Much thanks for a feedback. Please excuse me for delayed answer, we tried to collect all
> the required information before returning to you - but we are still working on it.
> 
> Best regards,
> M^2
> 
> > 
> > -----Original Message-----
> > From: Greg Kroah-Hartman <gregkh@linuxfoundation.org> 
> > Sent: Thursday, September 1, 2022 7:46 AM
> > To: Jakub Kicinski <kuba@kernel.org>
> > Cc: Nguyen, Anthony L <anthony.l.nguyen@intel.com>; davem@davemloft.net; pabeni@redhat.com; edumazet@google.com; Michalik, Michal <michal.michalik@intel.com>; netdev@vger.kernel.org; richardcochran@gmail.com; G, GurucharanX <gurucharanx.g@intel.com>; Jiri Slaby <jirislaby@kernel.org>; Johan Hovold <johan@kernel.org>
> > Subject: Re: [PATCH net 3/3] ice: Add set_termios tty operations handle to GNSS
> > 
> > On Wed, Aug 31, 2022 at 02:54:39PM -0700, Jakub Kicinski wrote:
> > > On Mon, 29 Aug 2022 15:00:49 -0700 Tony Nguyen wrote:
> > > > From: Michal Michalik <michal.michalik@intel.com>
> > > > 
> > > > Some third party tools (ex. ubxtool) try to change GNSS TTY parameters
> > > > (ex. speed). While being optional implementation, without set_termios
> > > > handle this operation fails and prevents those third party tools from
> > > > working.
> > 
> > What tools are "blocked" by this?  And what is the problem they have
> > with just the default happening here?  You are now doing nothing, while
> > if you do not have the callback, at least a basic "yes, we accepted
> > these values" happens which was intended for userspace to not know that
> > there was a problem here.
> > 
> 
> As I stated in the commit message, the example tool is ubxtool - while trying to
> connect to the GPS module the error appreared:
> Traceback (most recent call last):
> 
> 	  File "/usr/local/bin/ubxtool", line 378, in <module>
> 		io_handle = gps.gps_io(
> 	  File "/usr/local/lib/python3.9/site-packages/gps/gps.py", line 309, in __init__
> 		self.ser = Serial.Serial(
> 	  File "/usr/local/lib/python3.9/site-packages/serial/serialutil.py", line 244, in __init__
> 		self.open()
> 	  File "/usr/local/lib/python3.9/site-packages/serial/serialposix.py", line 332, in open
> 		self._reconfigure_port(force_update=True)
> 	  File "/usr/local/lib/python3.9/site-packages/serial/serialposix.py", line 517, in _reconfigure_port
> 		termios.tcsetattr(
> 	termios.error: (22, 'Invalid argument')
> 	
> Adding this empty function solved the problem.

That seems very wrong, please work to fix this by NOT having an empty
function like this as it should not be required.

thanks,

greg k-h
