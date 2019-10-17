Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4708ADB15C
	for <lists+netdev@lfdr.de>; Thu, 17 Oct 2019 17:44:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406300AbfJQPoi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Oct 2019 11:44:38 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:42032 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404351AbfJQPoi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Oct 2019 11:44:38 -0400
Received: by mail-pl1-f196.google.com with SMTP id e5so1304167pls.9
        for <netdev@vger.kernel.org>; Thu, 17 Oct 2019 08:44:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=T1gCpiuac4e+eG/7Tf8hkxJmB23XUVvAbKCA3FREPJo=;
        b=hv/7osS+1u9AJFHz7n+9SP+L9qyPaFSJl/MyP3C0d/QwH6PNQmpXBOfJPYEAEeC6d2
         raoxi0Mmr4EMPrJm0zQp/kgZiMQqBafnsm55L1vEdmV42TxiPs8UfwkCe/3hEOyB07Bl
         PRNrYA/bCRf17gsItcPEZ6wkf9uLv2adXAI5spBh/zCpirZ3y72iIieN7Fa/8+ayL5aO
         ENr35AuIueJygQhX//EZoNsmuo5Np0bLH51rPsZQ0P9TTYdwZ8EzcWGCVaiXOXLE4p9l
         t+uOAyC8dTyXjKvrkAFYKd7AEyNolwXHWKuyw9ocIBZ8JCR+3YHMojyMkBJMBhf51/tO
         HLzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=T1gCpiuac4e+eG/7Tf8hkxJmB23XUVvAbKCA3FREPJo=;
        b=gCyr6LfrZRC11e6yizlXtmIEd8gq+DQUc9ivSXuHPrjCDBly1M+uE1BF6h7fDNlEGq
         DS+DbHRh/fjeGB8KbMxOKxXY9SfAJJef9mifIpKI04AJGwZyZU2atOopPQ0d+y8Caux4
         Qx3WTGUFKyCQIAFuOHoBMXLAuD6ymC1PWoLWPkIPQC53KUmoJLXqUlhkoWdDFYwLItJu
         jJXkz/Oaybg1aFZU/+j83KjJYA+LBlnGA1L+uALy+9vsh/NckTiuG0l8kExYTWlFzXv2
         7kdrvrSLSEqVNJSe0+D1/cViEadfc98TofWdBZ/wIcJ634jLKw8CjnVu/9AwaKI4TeQ2
         k+Vw==
X-Gm-Message-State: APjAAAVYo0p3vc86oRxNIFdfFxGnHAILwM4WnVVe7ge7xumsXjRALtE0
        cTzs6EbDC4jW44djN0AeUMFMxg==
X-Google-Smtp-Source: APXvYqyyd16hD3VDZu9id5HYzX1h84FrKcu+pR0zKV1+aHAHz4CM9f1m3hq20ZHKN6LLQ/YAqXxKtw==
X-Received: by 2002:a17:902:8d8e:: with SMTP id v14mr4683496plo.287.1571327077517;
        Thu, 17 Oct 2019 08:44:37 -0700 (PDT)
Received: from cakuba.netronome.com (c-73-202-202-92.hsd1.ca.comcast.net. [73.202.202.92])
        by smtp.gmail.com with ESMTPSA id v35sm2996257pgn.89.2019.10.17.08.44.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Oct 2019 08:44:37 -0700 (PDT)
Date:   Thu, 17 Oct 2019 08:44:33 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Robert Beckett <bob.beckett@collabora.com>
Cc:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>, davem@davemloft.net,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        Aaron Brown <aaron.f.brown@intel.com>
Subject: Re: [net-next 2/7] igb: add rx drop enable attribute
Message-ID: <20191017084433.18bce3d4@cakuba.netronome.com>
In-Reply-To: <a575469d3b2a12d24161d0c6b0a6bff538e066b6.camel@collabora.com>
References: <20191016234711.21823-1-jeffrey.t.kirsher@intel.com>
        <20191016234711.21823-3-jeffrey.t.kirsher@intel.com>
        <20191016165531.26854b0e@cakuba.netronome.com>
        <a575469d3b2a12d24161d0c6b0a6bff538e066b6.camel@collabora.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 17 Oct 2019 12:24:03 +0100, Robert Beckett wrote:
> On Wed, 2019-10-16 at 16:55 -0700, Jakub Kicinski wrote:
> > On Wed, 16 Oct 2019 16:47:06 -0700, Jeff Kirsher wrote:  
> > > From: Robert Beckett <bob.beckett@collabora.com>
> > > 
> > > To allow userland to enable or disable dropping packets when
> > > descriptor
> > > ring is exhausted, add RX_DROP_EN private flag.
> > > 
> > > This can be used in conjunction with flow control to mitigate
> > > packet storms
> > > (e.g. due to network loop or DoS) by forcing the network adapter to
> > > send
> > > pause frames whenever the ring is close to exhaustion.
> > > 
> > > By default this will maintain previous behaviour of enabling
> > > dropping of
> > > packets during ring buffer exhaustion.
> > > Some use cases prefer to not drop packets upon exhaustion, but
> > > instead
> > > use flow control to limit ingress rates and ensure no dropped
> > > packets.
> > > This is useful when the host CPU cannot keep up with packet
> > > delivery,
> > > but data delivery is more important than throughput via multiple
> > > queues.
> > > 
> > > Userland can set this flag to 0 via ethtool to disable packet
> > > dropping.
> > > 
> > > Signed-off-by: Robert Beckett <bob.beckett@collabora.com>
> > > Tested-by: Aaron Brown <aaron.f.brown@intel.com>
> > > Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>  
> > 
> > How is this different than enabling/disabling flow control..
> > 
> > ethtool -a/-A  
> 
> Enabling flow control enables the advertisement of flow control
> capabilites and allows negotiation with link partner.

More or less. If autoneg is on it controls advertised bits,
if autoneg is off it controls the enabled/disable directly.

> It does not dictate under which circumstances those pause frames will
> be emitted.

So you're saying even with pause frames on igb by default will not
backpressure all the way to the wire if host RX ring is full/fill ring
is empty?

> This patch enables an igb specific feature that can cause flow control
> to be used. The default behaviour is to drop packets if the rx ring
> buffer fills. This flag tells the driver instead to emit pause frames
> and not drop packets, which is useful when reliable data delivery is
> more important than throughput.

The feature looks like something easily understood with a standard NIC
model in mind. Therefore it should have a generic config knob not a
private flag.
