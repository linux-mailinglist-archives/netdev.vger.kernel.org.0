Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 63152FE598
	for <lists+netdev@lfdr.de>; Fri, 15 Nov 2019 20:28:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726613AbfKOT22 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Nov 2019 14:28:28 -0500
Received: from mail-lf1-f66.google.com ([209.85.167.66]:37664 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726466AbfKOT22 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Nov 2019 14:28:28 -0500
Received: by mail-lf1-f66.google.com with SMTP id b20so8855246lfp.4
        for <netdev@vger.kernel.org>; Fri, 15 Nov 2019 11:28:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=uvgjJEg8EIWKeB1XBnyt33chTW7fA4gpna4jP6od8Bo=;
        b=HcBU8VkC8+vg6rcHtdMPO6n6bDoOaW1GiNKefeOfYnKW01UZP1j+drIVza2nq5rdFw
         qn7VqB0rDs5miE9If05YMJiVC4Of0E49o0svy6iujsjohr8zlRJK/hg3G2Vx1db3HEt1
         kBOGqCxGczcHuMQtFS1IKSsumoHzX0WQzGRTXUcmtL6YjTzC7jUlM0xeYHlrmFHbTRxu
         qd5kY98UsW0mvRw9XPjzTv2FF58/8PAUDcSgBPU2Yz9G0HnnYEYLuVSgY98SpcaCIzEe
         g6tSnw9Dk/gvAf6VSRXrTyyA+GG0FQ91ef+UhpP9MSOUSh9sWdUor6smpLM91rxkBrFp
         vrCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=uvgjJEg8EIWKeB1XBnyt33chTW7fA4gpna4jP6od8Bo=;
        b=tbozgFZ8B+gLAuVl1RdGwGpIP76qv+86XbI4B2sI5Lnr9Lj/p0AQpbxzIOQ3LGlZHw
         bPLbg5pRQX5rvehy9e0yEAlflEE0OJJHkX9TxmWzxPsVxrnJzJ/vktzeA+jIsnk/6OGq
         D1u4tzUPHD8mVNb9H3rja4TCyFqQBRqflVscKVc9+pqsoG+bKqeJk1jzveHmYZZ0++lA
         6WfLnq6gmikpAFzif1PrWI0GfRLRZRauDVUOpaJJ2l+2f0jdXQKm7/193bNmQ4RTVQnd
         ysnKgmbPX0Q80lf7CxtZY42BWibfyX4nGs5zAnYIcOOhG2+MqyvjHo+4kqamSKmUTYW6
         GQDg==
X-Gm-Message-State: APjAAAVmXDlkirjmgSvBazvUFZ/c1lZ2ONKHWfTEDQvtvZfTebGZsA4F
        zLF4V+0tEiG7bSDxLp56CkpHHw==
X-Google-Smtp-Source: APXvYqysYaSDr9msyG53jdP1LzRrDubH5jzxbNnBeekNDos/tzsbyZFMH40CgOxf5+Xk9m416JDZ3w==
X-Received: by 2002:ac2:4d17:: with SMTP id r23mr12728896lfi.56.1573846106482;
        Fri, 15 Nov 2019 11:28:26 -0800 (PST)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id i28sm4826297lfo.34.2019.11.15.11.28.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Nov 2019 11:28:26 -0800 (PST)
Date:   Fri, 15 Nov 2019 11:28:17 -0800
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
Cc:     Jiri Pirko <jiri@resnulli.us>, netdev@vger.kernel.org,
        davem@davemloft.net, nirranjan@chelsio.com, vishal@chelsio.com,
        dt@chelsio.com
Subject: Re: [PATCH net-next v3 1/2] cxgb4: add TC-MATCHALL classifier
 egress offload
Message-ID: <20191115112817.3b7d0c13@cakuba.netronome.com>
In-Reply-To: <20191115190056.GA14695@chelsio.com>
References: <cover.1573818408.git.rahul.lakkireddy@chelsio.com>
        <5b5af4a7ec3a6c9bc878046f4670a2838bbbe718.1573818408.git.rahul.lakkireddy@chelsio.com>
        <20191115135845.GC2158@nanopsycho>
        <20191115150824.GA14296@chelsio.com>
        <20191115153247.GD2158@nanopsycho>
        <20191115105112.17c14b2b@cakuba.netronome.com>
        <20191115190056.GA14695@chelsio.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 16 Nov 2019 00:30:57 +0530, Rahul Lakkireddy wrote:
> > > I don't think that is correct. If matchall is the only filter there, it
> > > does not matter which prio is it. It matters only in case there are
> > > other filters.  
> > 
> > Yup, the ingress side is the one that matters.
> >   
> > > The code should just check for other filters and forbid to insert the
> > > rule if other filters have higher prio (lower number).  
> > 
> > Ack as well, that'd work even better. 
> > 
> > I've capitulated to the prio == 1 condition as "good enough" when
> > netronome was adding the policer offload for OvS.  
> 
> I see. I thought there was some sort of mutual agreement, that to
> offload police, then prio must be 1, when I saw several drivers do
> it. I don't have a police offload on ingress side yet. So, I'm
> guessing this check for prio is not needed at all for my series?
> Please confirm again so that I'm on the same page. :)

You still need to make sure that Hw orders the rules the same as SW
would. If there are lower prio flower offloads added first and then
high prio matchall rule, the flower filters should no longer match.
And vice versa if higher prio flower rules are inserted after match 
all they should take precedence.

If that's how it currently works then all is good, but I don't see the
relevant checks anywhere.

As Jiri suggested, you can narrow the scope to whatever you're actual
use case requires. For example simply refuse to offload the filters if
it would require reordering or ejecting rules from HW.
