Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC9FC69C842
	for <lists+netdev@lfdr.de>; Mon, 20 Feb 2023 11:09:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229678AbjBTKJV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Feb 2023 05:09:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229609AbjBTKJU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Feb 2023 05:09:20 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A02B4A278
        for <netdev@vger.kernel.org>; Mon, 20 Feb 2023 02:08:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1676887711;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=i2sXIx2V03F78IC20RzS2YHYtqHsVe4hWJXkrNDA5fg=;
        b=AwBAEFb/MuyUfTnu4AsTzeDmKFCjdAIKVE/yRw0krekR0Qk9yB2WO2LXQZ4L6ZlEH/2lXQ
        zBXJ2FfxevF7th8W28/AwBDG/WzMVS0Y4LKglkW6R4f/jzr4y9pG6+x3q8BncPusCjM9jI
        bFxU8NZzy03TkYRSF+JdkOhxnsWf3mA=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-488-24EzMJhQOOCSpTni-hRTpQ-1; Mon, 20 Feb 2023 05:08:27 -0500
X-MC-Unique: 24EzMJhQOOCSpTni-hRTpQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EAECB85CCE1;
        Mon, 20 Feb 2023 10:08:26 +0000 (UTC)
Received: from localhost (unknown [10.43.135.229])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 0824B40C1423;
        Mon, 20 Feb 2023 10:08:25 +0000 (UTC)
Date:   Mon, 20 Feb 2023 11:08:23 +0100
From:   Miroslav Lichvar <mlichvar@redhat.com>
To:     Richard Cochran <richardcochran@gmail.com>
Cc:     Matt Corallo <ntp-lists@mattcorallo.com>,
        chrony-dev@chrony.tuxfamily.org,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [chrony-dev] Support for Multiple PPS Inputs on single PHC
Message-ID: <Y/NGl06m04eR2PII@localhost>
References: <72ac9741-27f5-36a5-f64c-7d81008eebbc@bluematt.me>
 <Y+3m/PpzkBN9kxJY@localhost>
 <0fb552f0-b069-4641-a5c1-48529b56cdbf@bluematt.me>
 <Y+60JfLyQIXpSirG@hoboy.vegasvil.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y+60JfLyQIXpSirG@hoboy.vegasvil.org>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 16, 2023 at 02:54:29PM -0800, Richard Cochran wrote:
> Each extts in the fifo is delivered only once.  If there are multiple
> readers, each reader will receive only some of the data.  This is
> similar to how a pipe behaves.

Does it need to be that way? It seems strange for the kernel to
support enabling PPS on multiple channels at the same time, but not
allow multiple applications to receive all samples from their channel.

-- 
Miroslav Lichvar

