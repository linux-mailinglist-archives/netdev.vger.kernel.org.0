Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1EEE1678B9C
	for <lists+netdev@lfdr.de>; Tue, 24 Jan 2023 00:02:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231703AbjAWXCK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Jan 2023 18:02:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231638AbjAWXCI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Jan 2023 18:02:08 -0500
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C86F5242;
        Mon, 23 Jan 2023 15:01:35 -0800 (PST)
Received: by mail-ed1-x534.google.com with SMTP id y11so16376150edd.6;
        Mon, 23 Jan 2023 15:01:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=mzfL1sys7tR/U9dWeCKh9/M6xQgFrn17BxPfMKcz5Z4=;
        b=FLcyJAD7atSBhN4+y4EoSFcDRHJb9hRgu3setrWHeR0oAllKDsfhe/KnrqHiEZNu2o
         6KL7AZdcnPFUnQCPiTmt7lwYr+GCmS0K2jNrwSIc3Z51u9QAI0MOApx2MjQNURuX4InA
         XdCNqZeaOznz25BHrP58xgmJ0z5jaGbrqfXsbV4vBIARe7m7cHyOccLm+lhBLNSlKQkG
         wIi1PqIGheNvSZNO/wV5Bw+4BQ2orn+MhSf96y2UhQP1aCX/xm9IpJc794aLzRLr5+Sc
         D2kKuurIjLDEFs3+2rRjDDHzO2uROgD/WVghMy+iTLTaLzWiIaqKtrM6cv0WZEN/kll4
         qKhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mzfL1sys7tR/U9dWeCKh9/M6xQgFrn17BxPfMKcz5Z4=;
        b=x/52zTILIk1nImyozBuatMCoH6kBpqdEjux2jP859c/8cKAnc4sAqd1L5VPUf0PnpY
         CevuD9T1YPa95pG7LQYBLczaFNzjeYjr0HXGN8A7wr/H/joFBQVwUpubJnz+fBEGv0jo
         rjNd50xlaG6anhfQ6Yk1iJ4LjVmwjO6OUOA0RtYo7YJ7a0+Aplg70kHZfOjnVS0q5B+D
         xC5FoJ4glYEjyQrt7ttFs+MZ6cjyf9DKHVqP+Yl9kJAaiwzNhlON99grWDxHW7jVE7h0
         XivGrCVYG8SMMpzb7zNi+lKDRDQQn3nSnIZA19hGBoa4pk/jNWRPkR3O7eivP38X9l5t
         9ocw==
X-Gm-Message-State: AFqh2kpwzWsdh8Jq/ogv30bueW/03j1IN5PaVnAKaXFN1K+vDf5iebPg
        bLfza4ZkevH2dlNAJHsU9Ofb52FJ3WskvIqcyrE=
X-Google-Smtp-Source: AMrXdXsoiStQlHWPiJm8U5NmtegkmsJd4KpVQAT1RSJpSLSejq7iEx8OwoQYks9IEA1z/jidLjp+5Q==
X-Received: by 2002:aa7:d392:0:b0:484:7560:1a77 with SMTP id x18-20020aa7d392000000b0048475601a77mr27603201edq.16.1674514884250;
        Mon, 23 Jan 2023 15:01:24 -0800 (PST)
Received: from localhost ([103.251.167.10])
        by smtp.gmail.com with ESMTPSA id v16-20020aa7dbd0000000b00458b41d9460sm280372edt.92.2023.01.23.15.01.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Jan 2023 15:01:23 -0800 (PST)
Date:   Tue, 24 Jan 2023 01:01:21 +0200
From:   Maxim Mikityanskiy <maxtram95@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Hariprasad Kelam <hkelam@marvell.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "edumazet@google.com" <edumazet@google.com>,
        Sunil Kovvuri Goutham <sgoutham@marvell.com>,
        Linu Cherian <lcherian@marvell.com>,
        Geethasowjanya Akula <gakula@marvell.com>,
        Jerin Jacob Kollanukkaran <jerinj@marvell.com>,
        Subbaraya Sundeep Bhatta <sbhatta@marvell.com>,
        "jhs@mojatatu.com" <jhs@mojatatu.com>,
        "xiyou.wangcong@gmail.com" <xiyou.wangcong@gmail.com>,
        "jiri@resnulli.us" <jiri@resnulli.us>,
        "saeedm@nvidia.com" <saeedm@nvidia.com>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>,
        "tariqt@nvidia.com" <tariqt@nvidia.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "hariprasad.netdev@gmail.com" <hariprasad.netdev@gmail.com>,
        Naveen Mamindlapalli <naveenm@marvell.com>
Subject: Re: [net-next Patch v2 4/5] octeontx2-pf: Add devlink support to
 configure TL1 RR_PRIO
Message-ID: <Y88Rug7iaC0nOGvu@mail.gmail.com>
References: <20230118105107.9516-1-hkelam@marvell.com>
 <20230118105107.9516-5-hkelam@marvell.com>
 <Y8hYlYk/7FfGdfy8@mail.gmail.com>
 <PH0PR18MB4474FCEAC4FA5907CAC17011DEC59@PH0PR18MB4474.namprd18.prod.outlook.com>
 <Y8qZNhUgsdOMavC4@mail.gmail.com>
 <PH0PR18MB4474DBEF155EFA4DA6BA5B10DEC59@PH0PR18MB4474.namprd18.prod.outlook.com>
 <Y803rePcLc97CGik@mail.gmail.com>
 <PH0PR18MB44741D5EBBD7B4010C78C7DFDEC89@PH0PR18MB4474.namprd18.prod.outlook.com>
 <Y87onaDuo8NkFNqC@mail.gmail.com>
 <20230123144548.4a2c06ae@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230123144548.4a2c06ae@kernel.org>
X-Spam-Status: No, score=1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 23, 2023 at 02:45:48PM -0800, Jakub Kicinski wrote:
> On Mon, 23 Jan 2023 22:05:58 +0200 Maxim Mikityanskiy wrote:
> > OK, I seem to get it now, thanks for the explanation!
> > 
> > How do you set the priority for HTB, though? You mentioned this command
> > to set priority of unclassified traffic:
> > 
> > devlink -p dev param set pci/0002:04:00.0 name tl1_rr_prio value 6 \
> > cmode runtime
> > 
> > But what is the command to change priority for HTB?
> > 
> > What bothers me about using devlink to configure HTB priority is:
> > 
> > 1. Software HTB implementation doesn't have this functionality, and it
> > always prioritizes unclassified traffic. As far as I understand, the
> > rule for tc stuff is that all features must have a reference
> > implementation in software.
> > 
> > 2. Adding a flag (prefer unclassified vs prefer classified) to HTB
> > itself may be not straightforward, because your devlink command has a
> > second purpose of setting priorities between PFs/VFs, and it may
> > conflict with the HTB flag.
> 
> If there is a two-stage hierarchy the lower level should be controlled
> by devlink-rate, no?

From the last picture by Hariprasad, I understood that the user sets all
priorities (for unclassified traffic per PF and VF, and for HTB traffic)
on the same TL2 level, i.e. it's not two-stage. (Maybe I got it all
wrong again?)

I asked about the command to change the HTB priority, cause the
parameters aren't easily guessed, but I assume it's also devlink (i.e.
driver-specific).

If there were two levels (the upper level chooses who goes first: HTB or
unclassified, and the lower level sets priorities per PF and VF for
unclassified traffic), that would be more straightforward to solve: the
upper level should be controlled by a new HTB parameter, and the lower
level is device-specific, thus it goes to devlink.
