Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CED2F5AFBE7
	for <lists+netdev@lfdr.de>; Wed,  7 Sep 2022 07:46:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229797AbiIGFp6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Sep 2022 01:45:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229821AbiIGFpt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Sep 2022 01:45:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D53E2419A7
        for <netdev@vger.kernel.org>; Tue,  6 Sep 2022 22:45:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7EB45B81B55
        for <netdev@vger.kernel.org>; Wed,  7 Sep 2022 05:45:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54101C433B5;
        Wed,  7 Sep 2022 05:45:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662529544;
        bh=nMfUHk4CgQ1O80w2uXZNoc3RbnLVQ6NZOM4mWrEYuZk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=gv/2hxFlNn56FCKJXEY+jkROM375O9GQNmbQhvsS/176PDLPHvkyBaFgIKQBvYot9
         IKwa4Gv9L+VByteFekLTpgTyezv1a3sDlp+JuDsGKiQNsAMXEw8JR0ua1n1lusif4e
         kkS/PjKXnN7skIucHlqMQDElSDHq29WEkaJXWjJs=
Date:   Wed, 7 Sep 2022 07:45:39 +0200
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
Message-ID: <YxgwA9bTvdheeZUf@kroah.com>
References: <20220829220049.333434-1-anthony.l.nguyen@intel.com>
 <20220829220049.333434-4-anthony.l.nguyen@intel.com>
 <20220831145439.2f268c34@kernel.org>
 <YxBHL6YzF2dAWf3q@kroah.com>
 <BN6PR11MB417756CED7AE9DF7C3FA88DCE37F9@BN6PR11MB4177.namprd11.prod.outlook.com>
 <YxbliLlS9YU6eKMn@kroah.com>
 <BN6PR11MB4177F526AA1726DC0EF95E62E37E9@BN6PR11MB4177.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN6PR11MB4177F526AA1726DC0EF95E62E37E9@BN6PR11MB4177.namprd11.prod.outlook.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 06, 2022 at 08:55:59PM +0000, Michalik, Michal wrote:
> Greg,
> 
> Thanks - answer inline.

As is required, no need to put this on your emails, as top-posting is
not allowed :)

> > -----Original Message-----
> > From: Greg Kroah-Hartman <gregkh@linuxfoundation.org> 
> > Sent: Tuesday, September 6, 2022 8:16 AM
> > To: Michalik, Michal <michal.michalik@intel.com>
> > Cc: Jakub Kicinski <kuba@kernel.org>; Nguyen, Anthony L <anthony.l.nguyen@intel.com>; davem@davemloft.net; pabeni@redhat.com; edumazet@google.com; netdev@vger.kernel.org; richardcochran@gmail.com; G, GurucharanX <gurucharanx.g@intel.com>; Jiri Slaby <jirislaby@kernel.org>; Johan Hovold <johan@kernel.org>
> > Subject: Re: [PATCH net 3/3] ice: Add set_termios tty operations handle to GNSS

Please fix your email client to not do this.

> > > Adding this empty function solved the problem.
> > 
> > That seems very wrong, please work to fix this by NOT having an empty
> > function like this as it should not be required.
> > 
> 
> I don't get one thing, though. You are saying, it "seem" wrong and that
> "should not" be required but I observe different behavior. I have prepared
> a very simple code to reproduce the issue:
> 	#include <termios.h>
> 	#include <unistd.h>
> 	#include <stdio.h>
> 	#include <fcntl.h>
> 	#include <errno.h>
> 
> 	int main()
> 	{
> 		struct termios tty;
> 		int fd;
> 		
> 		fd = open("/dev/ttyGNSS_0300", O_RDWR | O_NOCTTY | O_SYNC);
> 
> 		if (fd < 0) {
> 				printf("Error - TTY not open.\n");
> 				return -1;
> 		}
> 				
> 		if (tcgetattr (fd, &tty) != 0) {
> 			printf("Error on get - errno=%i\n", errno);
> 			return -1;
> 		}
> 		tty.c_cflag |= CS8; // try to set 8 data bits 
> 		if (tcsetattr(fd, TCSANOW, &tty) != 0) {
> 			printf("Error on set - errno=%i\n", errno);
> 			return -1;
> 		}
> 
> 		close(fd);
> 		printf("Done.\n");
> 	}
> 
> In this case, when I don't satisfy this API, I get an errno 22.

You get the error on the first get or the set?

> If add this
> empty function and therefore implement the full API it works as expected (no
> error). In our case no action is needed, therefore we have an empty function.
> At the moment, I'm not sure how I should fix it other way - since no action
> on HW is neccessary.

This should not be needed as I thought the default would be "just ignore
this", but maybe not.  Can you look into this problem please and figure
out why this is required and fix that up?

> Of course in the meantime we are working on investigating if we can easily
> align to existing GNSS interface accroding to community suggestions. Still,
> we believe that this fix is solving the problem at the moment. 

Let's fix the root problem here, not paper over it.

thanks,

greg k-h
