Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 248D33BFC0
	for <lists+netdev@lfdr.de>; Tue, 11 Jun 2019 01:12:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390504AbfFJXMB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jun 2019 19:12:01 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:38230 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390340AbfFJXMA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jun 2019 19:12:00 -0400
Received: by mail-pg1-f194.google.com with SMTP id v11so5809476pgl.5
        for <netdev@vger.kernel.org>; Mon, 10 Jun 2019 16:12:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=iGa2muT+9X1Dtqir2y+m/svzAzGaniQ5AdPHhpLhDpE=;
        b=YsKDoCPqXL4gYlhf1kT1Sc3VGfaxN0rj1GmTuo5qY7NMRLes5kgewwn0SEML7YHuCx
         1dQnII1jwBlvX6e29KXkE4yP9AhW2bRFLWqNLeql/mvkV51J5jHgSRKKPE2QQZsdTmhD
         OP+1RTDogrpMSSaPoYprnhEu8j96HIbyNeUfm1Lmf9P2G5fJ0M6WdUxRY6JYB/4DBftg
         egTS6ecKDhLusrm6emB44CF0ZCr0UTE0V0LF8rTud/BsQnRBnGJndGv3zk7pnNEsbTiv
         gayKfjZoLyoJnQMp06DLW1BY1cTzCS39z+WUboA2Eg5MfSHVvPlvAnHOMdS7dqLOzaZ6
         EOWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=iGa2muT+9X1Dtqir2y+m/svzAzGaniQ5AdPHhpLhDpE=;
        b=ajBHEBZJTaLjufTpcnsWdk6VbTLI52yr2RbMOrXLnv39Kxa9MmL0Y5q/Ln4Nx8KnYj
         u3YiQ1UpB9I2SZK5lZZfi5RQI36Uvyc+ojDAoJAmjnlvJQLICARhNsz5LKHkLs8e5nbi
         oLgD67i9AI/hyHnYFK3U5wSaf/gbfTpI7KTMeGYZM8euAmn6rdXU9J/NBgYwIwk+h57O
         vNUsJ18Leh7zmNKa6xTPfBPJkTEgM6kq0eBACrYBbZUOmV8oRxVN0J++VJ4iwGmBczWl
         u4Doai8SXeiMn2ns+hO0gFvdtqHABwqfmO+z+DU3VXlqHdBcbDFk0WQNSmBmlLtJc+Wt
         Ff/Q==
X-Gm-Message-State: APjAAAXaD85CvTog8oyynoK/Qu+QxCS5zKAHVAVrgivtPqlNMF/rWjgQ
        GVLzwTZFNU3t5LSDiPkxavQjQg==
X-Google-Smtp-Source: APXvYqxVIQ2JnJNcPsLdnsQSsHqfgV+6gKeoXlzdtKzi/bY0G3JBILJwaQkxQ6Wjnv5ooQAn2YG2jA==
X-Received: by 2002:a17:90a:32ed:: with SMTP id l100mr23399850pjb.11.1560208320110;
        Mon, 10 Jun 2019 16:12:00 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id j7sm11483830pfa.184.2019.06.10.16.11.59
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 10 Jun 2019 16:12:00 -0700 (PDT)
Date:   Mon, 10 Jun 2019 16:11:53 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Matteo Croce <mcroce@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>, David Ahern <dsahern@kernel.org>
Subject: Re: [PATCH iproute2 1/2] netns: switch netns in the child when
 executing commands
Message-ID: <20190610161153.1f397e1a@hermes.lan>
In-Reply-To: <CAGnkfhz==DcWNkqmqGXhxCx7B4wQuBF9F1rRhnvoA-v+vBCoRw@mail.gmail.com>
References: <20190610221613.7554-1-mcroce@redhat.com>
        <20190610221613.7554-2-mcroce@redhat.com>
        <20190610154552.4dfa54af@hermes.lan>
        <CAGnkfhyJeN853gmNX+Op88b4OTkuQdQt==FttFdb4WVPNmQ7zA@mail.gmail.com>
        <CAGnkfhz==DcWNkqmqGXhxCx7B4wQuBF9F1rRhnvoA-v+vBCoRw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 11 Jun 2019 01:03:57 +0200
Matteo Croce <mcroce@redhat.com> wrote:

> On Tue, Jun 11, 2019 at 12:52 AM Matteo Croce <mcroce@redhat.com> wrote:
> >
> > On Tue, Jun 11, 2019 at 12:46 AM Stephen Hemminger
> > <stephen@networkplumber.org> wrote:  
> > >
> > > On Tue, 11 Jun 2019 00:16:12 +0200
> > > Matteo Croce <mcroce@redhat.com> wrote:
> > >  
> > > > +     printf("\nnetns: %s\n", nsname);
> > > > +     cmd_exec(argv[0], argv, true, nsname);
> > > >       return 0;  
> > >
> > > simple printf breaks JSON output.  
> >
> > It was just moved from on_netns_label(). I will check how the json
> > output works when running doall and provide a similar behaviour.
> >
> > Anyway, I noticed that the VRF env should be reset but only in the
> > child. I'm adding a function pointer to cmd_exec which will
> > point to an hook which changes the netns when doing 'ip netns exec'
> > and reset the VRF on vrf exec.
> >
> > Regards,
> > --
> > Matteo Croce
> > per aspera ad upstream  
> 
> Hi Stephen,
> 
> just checked, but it seems that netns exec in batch mode produces an
> invalid output anyway:
> 
> # ip netns add n1
> # ip netns add n2
> # ip -all -json netns exec date
> 
> netns: n2
> Tue 11 Jun 2019 12:55:11 AM CEST
> 
> netns: n1
> Tue 11 Jun 2019 12:55:11 AM CEST
> 
> Probably there is very little sense in using -all netns exec and json
> together, but worth noting it.
> 
> Bye,

Thanks, just being paranoid about json output.
