Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A1024D0D19
	for <lists+netdev@lfdr.de>; Tue,  8 Mar 2022 01:57:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233280AbiCHA6I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Mar 2022 19:58:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344207AbiCHA6G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Mar 2022 19:58:06 -0500
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 113031155
        for <netdev@vger.kernel.org>; Mon,  7 Mar 2022 16:57:11 -0800 (PST)
Received: by mail-pg1-x529.google.com with SMTP id 27so14985090pgk.10
        for <netdev@vger.kernel.org>; Mon, 07 Mar 2022 16:57:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=UmjOFXj+ogPexl4LVdJMwHkncXdd2Q2dy+XfGeZt/z0=;
        b=WCSStIjvA1cf1SikZGDJu4bzhoV3MxKLgxaiQmGxzto11DsaM4gN3JEybm0zVfj9eo
         Yr/wxcz7fML79RYVlTT6beLHboVTPvNZBHAhCg6/XbEAZ24a2pC+pDMGjXsuLk976cWT
         TGlalDq08eTVt9CXZA0VhIy4epA8JlcK0ML4HIb3BIXAQC6Qy/Nw4xN/RSLkZgmSDsyT
         oct16L1whubkwKRrQqb0ohLiEttWGueqUDgqaaJQMWcq4FBHhC8hrQ/YDRgrWT9hbG+Q
         D8i8F6fcHPlFP9QZ1qf6Xys3LcMhL76ndicB13bkjR6T9F2paNGlv0al9OGT0jyQGEw/
         jIDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=UmjOFXj+ogPexl4LVdJMwHkncXdd2Q2dy+XfGeZt/z0=;
        b=Jj/C53NQmbTXOCE+nUssOfygy7rm8FvuZHw8j2iqsuWuNpG4a75tc3w/FiyPqjX7K8
         pOniCVVf7czaTg4ZK+n0u/i/014a1s5Rc+3rNLri+XJ544D+PtqJm7ldwVifkqw4jJ4c
         vEBWZ02thxYtC1CTHmJBQ+LTFmShmIQdk9p0lT/7vOIp8oT9xhoImiH7uGKLC+2TJabi
         17WFVYxZcqw4is5QcuQvOVHFs07GJJ9N43p8P2Q8tEUsi1d3Pw32CPc4nsyHdWmYsfgN
         jIMeK5XbSP+S7WrNXbGsxmKUKe60uKGYUFFap+EF56lMnfzSCPbz1S99fHqc3DG0H0CN
         WPoQ==
X-Gm-Message-State: AOAM531D2kfDs/uVYECzvgmwOzpZzoJdNbXGOQMnF/nmhSFqDztEIB0Z
        5ElefvmV1PEwBbJ5S0F3aOA=
X-Google-Smtp-Source: ABdhPJw/acvMXyCxUCFwKHYyJgACzL66jB0XYpTJS+ajhiAKeAhwrsf1NNir+uHOWaww3B/yUN7yEA==
X-Received: by 2002:a05:6a00:2481:b0:4f6:b71f:3330 with SMTP id c1-20020a056a00248100b004f6b71f3330mr15712753pfv.47.1646701030602;
        Mon, 07 Mar 2022 16:57:10 -0800 (PST)
Received: from hoboy.vegasvil.org ([2601:640:8200:33:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id x23-20020a63fe57000000b0036490068f12sm12877336pgj.90.2022.03.07.16.57.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Mar 2022 16:57:10 -0800 (PST)
Date:   Mon, 7 Mar 2022 16:57:07 -0800
From:   Richard Cochran <richardcochran@gmail.com>
To:     Gerhard Engleder <gerhard@engleder-embedded.com>
Cc:     yangbo.lu@nxp.com, David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, mlichvar@redhat.com,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        netdev <netdev@vger.kernel.org>
Subject: Re: [RFC PATCH net-next 0/6] ptp: Support hardware clocks with
 additional free running time
Message-ID: <20220308005707.GC6994@hoboy.vegasvil.org>
References: <20220306085658.1943-1-gerhard@engleder-embedded.com>
 <20220306170504.GE6290@hoboy.vegasvil.org>
 <CANr-f5wNJM4raaXrMA8if8gkUgMRrK7+5beCnpGOzoLu59zwsg@mail.gmail.com>
 <20220306215032.GA10311@hoboy.vegasvil.org>
 <20220307143440.GC29247@hoboy.vegasvil.org>
 <CANr-f5zyLX1YAW+D4AJn2MBQ8g7e8F+KVDc0GuxL7s9K89Qx_A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANr-f5zyLX1YAW+D4AJn2MBQ8g7e8F+KVDc0GuxL7s9K89Qx_A@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 07, 2022 at 06:54:19PM +0100, Gerhard Engleder wrote:

> For TX it is known which timestamp is required. So I would have to find a way
> to detect which timestamp shall be filled into hwtstamp.

How about tx_flags in struct skb_shared_info ?

Thanks,
Richard
