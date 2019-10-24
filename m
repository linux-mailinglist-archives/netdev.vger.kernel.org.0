Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 885CFE3791
	for <lists+netdev@lfdr.de>; Thu, 24 Oct 2019 18:12:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439748AbfJXQMN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Oct 2019 12:12:13 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:39865 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2439732AbfJXQMN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Oct 2019 12:12:13 -0400
Received: by mail-pf1-f196.google.com with SMTP id v4so15442380pff.6;
        Thu, 24 Oct 2019 09:12:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=I9gTKTY8dXIfST0vdAZ/EJgrRW810oQ1HZflmexaYVM=;
        b=VSYQSrqcQvc6m/dj8ueivZPOBcvxYDvUdnAikL6BPeYqG7sPOvIpiJxfzoULJ2Albc
         Y6Sgi1V2V57daNIzKQg0ayW0uQxUpGYx733lwcwSzS7vfATdLCVeXPLoTfaQgumLC3G1
         7USgWJmG8k6g9UQ1mIlAQHmPiOPV7EqH4L3VH0HvD/CVDh6PMIOKrTZnlVD5ak49byMu
         TPxT0HdZ4gwI2/jAV/BXQtAzIWg7lJXTLzWcoxH3Do35jqBREdPEwCugcLzNRFBNT2KF
         TwNS73J2rUWYIWivH7w98rQQSKM6vWOBFSNzDf6nYWW4ubeHDnZyMM08ZsSh5ERTikMw
         Jd3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=I9gTKTY8dXIfST0vdAZ/EJgrRW810oQ1HZflmexaYVM=;
        b=AjXqbJCW6u7QNxWevOg0EYHv3GUMkHD7b1uqqgflFMHSeW9nC1mhcc2vCISfCa8xT/
         80n8QnOlUsJR/NSJCurZbhJzlza8eQPLhx8W+Tykb0Z7/T8MaLqIASQ2histJ5yiz9zC
         6Mx0GAm59PQiRg4lUlixHrCebsymy0WudCZaBVjmi/ds5mHmmSpEPPLDBJjSZorv17hZ
         LDGoT8S9yFIW4+zjUWtwp4NdtUHPoXLquGFZlAOxwGbCX4i4o9m6tp4NzY5wwSCqQdzs
         2NTYHEIfHbADawk0ly9nUTuC15lRFegqXj2PdKjS2LTYwHQMYR2rf+81zs2iu911LAwR
         3DUQ==
X-Gm-Message-State: APjAAAViWNlMg3B6Zym9ih/Lb1CFVQaiK9WmBIKyBmfTt093b/HIAfEP
        x/cTrJA5k5TtOSSWmg3orsE=
X-Google-Smtp-Source: APXvYqzheI1ZTSlQ/VFxOTT5AwlSfrUcqiDnTZPK+ycMytv4Qo4yjscx+a/ZZ5PcjEsrTvrCdXHv0g==
X-Received: by 2002:a63:3203:: with SMTP id y3mr1102620pgy.437.1571933532198;
        Thu, 24 Oct 2019 09:12:12 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:200::3:c1d6])
        by smtp.gmail.com with ESMTPSA id 30sm28336041pgz.2.2019.10.24.09.12.10
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 24 Oct 2019 09:12:11 -0700 (PDT)
Date:   Thu, 24 Oct 2019 09:12:09 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Jakub Sitnicki <jakub@cloudflare.com>
Cc:     bpf@vger.kernel.org, John Fastabend <john.fastabend@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>, netdev@vger.kernel.org,
        kernel-team@cloudflare.com
Subject: Re: [RFC bpf-next 0/5] Extend SOCKMAP to store listening sockets
Message-ID: <20191024161208.nh2hgsgtscmmfl7w@ast-mbp.dhcp.thefacebook.com>
References: <20191022113730.29303-1-jakub@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191022113730.29303-1-jakub@cloudflare.com>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 22, 2019 at 01:37:25PM +0200, Jakub Sitnicki wrote:
> This patch set is a follow up on a suggestion from LPC '19 discussions to
> make SOCKMAP (or a new map type derived from it) a generic type for storing
> established as well as listening sockets.
> 
> We found ourselves in need of a map type that keeps references to listening
> sockets when working on making the socket lookup programmable, aka BPF
> inet_lookup [1].  Initially we repurposed REUSEPORT_SOCKARRAY but found it
> problematic to extend due to being tightly coupled with reuseport
> logic (see slides [2]). So we've turned our attention to SOCKMAP instead.
> 
> As it turns out the changes needed to make SOCKMAP suitable for storing
> listening sockets are self-contained and have use outside of programming
> the socket lookup. Hence this patch set.
> 
> With these patches SOCKMAP can be used in SK_REUSEPORT BPF programs as a
> drop-in replacement for REUSEPORT_SOCKARRAY for TCP. This can hopefully
> lead to code consolidation between the two map types in the future.
> 
> Having said that, the main intention here is to lay groundwork for using
> SOCKMAP in the next iteration of programmable socket lookup patches.
> 
> I'm looking for feedback if there's anything fundamentally wrong with
> extending SOCKMAP map type like this that I might have missed.

John, Martin,
comments?

