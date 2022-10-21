Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A556B607749
	for <lists+netdev@lfdr.de>; Fri, 21 Oct 2022 14:49:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229606AbiJUMtR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Oct 2022 08:49:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230099AbiJUMtN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Oct 2022 08:49:13 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC6B42681F4
        for <netdev@vger.kernel.org>; Fri, 21 Oct 2022 05:48:49 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id m6so2540226pfb.0
        for <netdev@vger.kernel.org>; Fri, 21 Oct 2022 05:48:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=5C3AVO3KQTZSkl5k56jSXrjjeWkXIjKnpVmOu2WKA+w=;
        b=j1MjZpD+ug0V6KhohONi2vJRizcJYRla7DkjaDonrhtb6ZWMDlcQe/1dN2rp8x4Rxp
         1IdL9k7mW5V3S29XHgxgn3eM/CQ+W6noeMlQR2kn3rUhNbPF0ukRzBBhtmgdQZc7AzrH
         8oFLnpLfLqpoTYBXTWXL7k0tC4ZnwD5slQW9fhjhPBDQMiOxav15pEuULmzftJLzttav
         2yTGq75fNO6nWxvBmXN0jxYf08giZO0gVe3N84hfeYJC3LMK1QxPTsdmZeK+UwHv28pd
         eeq8+GlNd+kxF0wCR0HmhT7pp1syG/sjuZiKdwYEN3Y/K0UaNwMSgc/2sjMVmClMpDq9
         6mJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5C3AVO3KQTZSkl5k56jSXrjjeWkXIjKnpVmOu2WKA+w=;
        b=pO3/Kei33H9NoSxWt0h5f5OTBq6Ab2VrH+DdOK4hIe2xBkg/bTqWal1EF/7g9YMWiw
         tYU/2OH6+Hp4EL1SLX3jVxWirWUHDwtjtcSdMVZFZT188ltsh9PW+0nizsWoGgze08a5
         jRWvlV9chdfPbDZgWlJQE1XXGEKHStxuO4SZ6RM60La5L5G+jtpyjvqCxnrB49OVvazj
         fTI1kFN2YchCZmuhJxeG9Nep6mjgjdXJG8I0lF2Knk5sVqsiPYU0nFpHURGHyM8e7TiL
         6aoFW5DBbasex/A/7oXcoE1Osp8vVI8EnrsMuhdaiG/5kFMIAMMMEAdg0tCAf98/hHto
         voOg==
X-Gm-Message-State: ACrzQf0N8dfTpTfW/krxr3GP9SXthW1opxPKsgQIxt7S1r253X1BUPop
        EPfJm9AmEnyBWJm+JTBrG9E=
X-Google-Smtp-Source: AMsMyM7l2QhXJZ8XnYp2zbPdQYvi0a48z/41cisCjeTh1CWC1Gzh62rJ3VQlyrUmnMeZriZmp84M+A==
X-Received: by 2002:a05:6a00:15ce:b0:562:cafb:2844 with SMTP id o14-20020a056a0015ce00b00562cafb2844mr19223942pfu.75.1666356527930;
        Fri, 21 Oct 2022 05:48:47 -0700 (PDT)
Received: from hoboy.vegasvil.org ([2601:640:8200:33:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id a15-20020a170902710f00b0017f8290fcc0sm14489927pll.252.2022.10.21.05.48.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Oct 2022 05:48:46 -0700 (PDT)
Date:   Fri, 21 Oct 2022 05:48:44 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     "Zulkifli, Muhammad Husaini" <muhammad.husaini.zulkifli@intel.com>
Cc:     "intel-wired-lan@osuosl.org" <intel-wired-lan@osuosl.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "Gunasekaran, Aravindhan" <aravindhan.gunasekaran@intel.com>,
        "gal@nvidia.com" <gal@nvidia.com>,
        "saeed@kernel.org" <saeed@kernel.org>,
        "leon@kernel.org" <leon@kernel.org>,
        "michael.chan@broadcom.com" <michael.chan@broadcom.com>,
        "andy@greyhouse.net" <andy@greyhouse.net>,
        "Gomes, Vinicius" <vinicius.gomes@intel.com>
Subject: Re: [PATCH v2 0/5] Add support for DMA timestamp for non-PTP packets
Message-ID: <Y1KVLAR2Qi6JeSBj@hoboy.vegasvil.org>
References: <20221018010733.4765-1-muhammad.husaini.zulkifli@intel.com>
 <Y06RzWQnTw2RJGPr@hoboy.vegasvil.org>
 <SJ1PR11MB618053D058C8171AAC4D3FADB8289@SJ1PR11MB6180.namprd11.prod.outlook.com>
 <Y09i12Wcqr0whToP@hoboy.vegasvil.org>
 <SJ1PR11MB6180F00C9051443BCEA22AB2B82D9@SJ1PR11MB6180.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <SJ1PR11MB6180F00C9051443BCEA22AB2B82D9@SJ1PR11MB6180.namprd11.prod.outlook.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 21, 2022 at 12:25:13AM +0000, Zulkifli, Muhammad Husaini wrote:

> Sorry for misinterpreting SOFTWARE as HARDWARE in my previous reply.
> DMA Timestamping is definitely better than SOFTWARE timestamp because 
> we sample the time at the controller MAC level.

Do you have numbers to back up this claim?

> Could you please provide additional details about this? What do you meant by 
> offering 1 HW Timestamp with many SW timestamps? 

- Let the PTP stack use hardware time stamps.

- Let all other applications use software time stamps.

Hm?

Thanks,
Richard
