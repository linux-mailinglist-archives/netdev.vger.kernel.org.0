Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2EA2B68A6D5
	for <lists+netdev@lfdr.de>; Sat,  4 Feb 2023 00:18:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232503AbjBCXSY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Feb 2023 18:18:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232119AbjBCXSW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Feb 2023 18:18:22 -0500
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2705E92C0C;
        Fri,  3 Feb 2023 15:18:20 -0800 (PST)
Received: by mail-ed1-x52d.google.com with SMTP id v10so6587008edi.8;
        Fri, 03 Feb 2023 15:18:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=x6/eiO29wfcStIlFa8Jf+yXo1tshpio0szyZTd2TTXk=;
        b=KOEDc/Zf7DxtpqtluxvBoUy0DFgRfFqOdkurXIwVDQEgEjdNovoX3qiO+Glz/qoVSe
         uwQSf5nowjD3rCkV6gAknZaRp3f35ydfEMmwV5zLnWQF667CHmHLGhP6FLv+bteg6SbW
         E98Wr+9gtFTxN1gm5d+5nZySYa46r6/9SxkNxtYFTHeM52k25TRlqNcqGcbWGGV5TNNk
         m6k3yF0r6ngdISl0P1oxtcmnN5B4++Dnt0aPTYTpaQYPubDsc5/yGv/ZOoFxsx7zohTq
         fi0vryhiZ6xyIZurBkxrbbwVzNghkbotcWDD4AF/VTXQQb42N+DsB7hev7RFV+NhQeib
         OB/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=x6/eiO29wfcStIlFa8Jf+yXo1tshpio0szyZTd2TTXk=;
        b=Z5oVBj05MzOmHXSs44+Gl2CJDi0oa7M23tTQtlY2haqMg1RSVSFNsAMSGo05ozbdvI
         ilb+sD7vUuXkcPV+jrcP/GWMOwtF/kgc9DTSt3h2HuF6sOkNeLbqaa1D0QTyQajOsGZa
         eNj+uAHKnMfuE+3F/CMUdKO0SQHX1J7OyKA8QUtKurlSlvTE5WPQDChw+9XI8BhFzxMO
         ntb0vLqCi3fF1oXBNOTEXk4jEO7IXk2ER0jCWb2zQKYt/xzVWvJCAk30BjCpMcxdyky7
         DVs7YjFurPU6mMF/k2/PNK7ddASvld+23wcmHyUbfw5VmXIdFFhyCUj/HBV5S55sL5mI
         eCgg==
X-Gm-Message-State: AO0yUKWDj1TjS0tN3tI5RV/rIx9ETtAu9UNz7gU4NuQrzGIdR4IR4M5y
        U6iLxd2YClWRobKoAoBPo4I=
X-Google-Smtp-Source: AK7set+U9t6LELz4QHb3KMtQCOp/x66OPpF2cr9dq/26itJt/TJukzSatqsf+3Fv4r5u2wwaPEmLFQ==
X-Received: by 2002:aa7:d402:0:b0:4a1:7a78:13f with SMTP id z2-20020aa7d402000000b004a17a78013fmr12575031edq.27.1675466298547;
        Fri, 03 Feb 2023 15:18:18 -0800 (PST)
Received: from skbuf ([188.26.57.116])
        by smtp.gmail.com with ESMTPSA id x10-20020a1709060a4a00b00880dbd4b6d4sm2003999ejf.136.2023.02.03.15.18.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Feb 2023 15:18:18 -0800 (PST)
Date:   Sat, 4 Feb 2023 01:18:15 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Rakesh Sankaranarayanan <rakesh.sankaranarayanan@microchip.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        andrew@lunn.ch, f.fainelli@gmail.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        woojung.huh@microchip.com, UNGLinuxDriver@microchip.com,
        linux@armlinux.org.uk
Subject: Re: [RFC PATCH net-next 02/11] net: dsa: microchip: lan937x: update
 SMI index
Message-ID: <20230203231815.mue2aeynxuwqpuzr@skbuf>
References: <20230202125930.271740-1-rakesh.sankaranarayanan@microchip.com>
 <20230202125930.271740-3-rakesh.sankaranarayanan@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230202125930.271740-3-rakesh.sankaranarayanan@microchip.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 02, 2023 at 06:29:21PM +0530, Rakesh Sankaranarayanan wrote:
> Current DSA driver register mdio interface for a port in the
> format of SMI-switch_index:port_number, switch_index is derived
> using variable ds->index. For a single switch ds->index will be
> always zero, and for cascaded switch, ds->index should be one.
> But it is found that ds->index is getting updated only after
> mdio_register stage. Update mdio_register to use variable directly
> from device tree using "dsa,member" identifier.
> 
> Signed-off-by: Rakesh Sankaranarayanan <rakesh.sankaranarayanan@microchip.com>
> ---

Impossible, check again.

The call path is:

ksz_switch_register()
-> dsa_register_switch()
   -> dsa_switch_probe()
      -> dsa_switch_parse_of()
         -> dsa_switch_parse_member_of()
            -> sets ds->index
      -> dsa_tree_setup()
         -> dsa_tree_setup_switches()
            -> dsa_switch_setup()
               -> ksz_setup()
                  -> ksz_mdio_register()
                     -> you claim ds->index isn't set

You don't even need to be an expert on the code path, you can grep for
"ds->index = ", put a dump_stack() where it's set and one where you need
it, and compare in the stack trace which functions are common and where
they diverge.
