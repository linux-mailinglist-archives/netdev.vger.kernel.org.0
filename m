Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11B775A6010
	for <lists+netdev@lfdr.de>; Tue, 30 Aug 2022 12:02:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229867AbiH3KCd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Aug 2022 06:02:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229851AbiH3KBm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Aug 2022 06:01:42 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC163DF48;
        Tue, 30 Aug 2022 02:59:53 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id 72so10830752pfx.9;
        Tue, 30 Aug 2022 02:59:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:subject:cc
         :to:from:date:message-id:from:to:cc;
        bh=oeIM3SY/f6yLZwemoFHSV24DbF45Rm+IqMcJltGrl4I=;
        b=i5pA0Ddzbd0FDWASI8YVCsV/XuhaEr8h+d9/sDXj9+lIhXUACOHj2RUn8nriBnpykY
         tWon+w1nhedxT4itCPVIr4TKQK+c2MiFGJOgQVzLXZWAK4epSDDWiV/ZKo2FTd9/ba09
         MF8+/pC9N8A+QC4Ov31+2CRPWgrrNtf931kQaKySwce+53al0AdjE+k9dYpu/r4bIzFx
         +FmXOkbhswjlehimi0RuAbWA/b8QyWn+YgfdRcypESDY+92wbggTCeQYXZxtHfJfG3N8
         ffwbOU3QuLmaH/4RxsBtMljlJ71sAmtOCK7eMXRQXXApJtFYcXOWZBkjRT0mWIQRhYcq
         RY7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:subject:cc
         :to:from:date:message-id:x-gm-message-state:from:to:cc;
        bh=oeIM3SY/f6yLZwemoFHSV24DbF45Rm+IqMcJltGrl4I=;
        b=k/QQFg/FYCPzJDqH27b2fnAjVD1HVX4JE5ZQQf/Jcd+h+2Cg6IJc/aKGqO+2gkzQy8
         oMiDoScB2oOvm+n62ueiqEzKneI7EeD3VQssbfrqCCchf8lj3APVmXKOGwA1pbyH1/If
         eykrWS4vG+LQA5UkSRhL9MOJStefFu/3g0Pm7388wPjwJAemf4dN+vGO+wntUvMsAKbj
         NxJWHpa/HBSXbe69XanR/V5dkGJmrQFJZPm7VMqj24lwqXHWrrMYRN2pvbfG4D2EKLDS
         JXMPVnugeJbgBeKcqlwBrs/fe/pyLUxjLq4w9h9WNRbJwUvq0WfR/6HBfKVYv44csOTY
         DDMA==
X-Gm-Message-State: ACgBeo0mFF2D1lyxc0DqUNhH0D8rC31ORhFgabaODdBONbiPBAYMdLyE
        4k24ulx3cts67RuHtpY9Ts8=
X-Google-Smtp-Source: AA6agR5JhBy+u1vJUShzas+bsXlOKLD7sbrWLQT+REXXYpNCnkZlQWyXcQ0RF4L7a3O074FhPMSJHw==
X-Received: by 2002:a63:83c8:0:b0:42b:908c:710 with SMTP id h191-20020a6383c8000000b0042b908c0710mr14152281pge.195.1661853593380;
        Tue, 30 Aug 2022 02:59:53 -0700 (PDT)
Received: from localhost ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id e15-20020a170902784f00b00172f4835f65sm7232407pln.271.2022.08.30.02.59.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Aug 2022 02:59:53 -0700 (PDT)
Message-ID: <630ddf99.170a0220.f0a66.bd54@mx.google.com>
X-Google-Original-Message-ID: <20220830095951.GB286783@cgel.zte@gmail.com>
Date:   Tue, 30 Aug 2022 09:59:51 +0000
From:   CGEL <cgel.zte@gmail.com>
To:     David Ahern <dsahern@kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org, yoshfuji@linux-ipv6.org,
        netdev@vger.kernel.org, linl@vger.kernel.org, xu.xin16@zte.com.cn
Subject: Re: [PATCH v2 0/3] Namespaceify two sysctls related with route
References: <20220824020051.213658-1-xu.xin16@zte.com.cn>
 <0c540a69-f7a4-dc71-c540-6e0785b2b5c9@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0c540a69-f7a4-dc71-c540-6e0785b2b5c9@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 25, 2022 at 08:27:04AM -0700, David Ahern wrote:
> On 8/23/22 7:00 PM, cgel.zte@gmail.com wrote:
> > From: xu xin <xu.xin16@zte.com.cn>
> > 
> > With the rise of cloud native, more and more container applications are
> > deployed. The network namespace is one of the foundations of the container.
> > The sysctls of error_cost and error_burst are important knobs to control
> > the sending frequency of ICMP_DEST_UNREACH packet for ipv4. When different
> > containers has requirements on the tuning of error_cost and error_burst,
> > for host's security, the sysctls should exist per network namespace.
> > 
> > Different netns has different requirements on the setting of error_cost
> > and error_burst, which are related with limiting the frequency of sending
> > ICMP_DEST_UNREACH packets. Enable them to be configured per netns.
> > 
> > 
> 
> you did not respond to the IPv6 question Jakub asked.
> 
> I think it is legacy for IPv4 since it pre-dates the move to git and
> just never added to IPv6. But, if it is important enough for this to
> move to per container then it should be important enough to add for IPv6
> too.

Probably yes, but however, there are still many applications using the
legacies for IPv4. Maybe it's not that important for IPv6 that have never
used it, but from the perspective of container's compatibility to host,
it is better to move to per container.
