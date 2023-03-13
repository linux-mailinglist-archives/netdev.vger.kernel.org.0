Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 737B36B75F5
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 12:29:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230062AbjCML3O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 07:29:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229740AbjCML3N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 07:29:13 -0400
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6170132CED;
        Mon, 13 Mar 2023 04:29:12 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id fm20-20020a05600c0c1400b003ead37e6588so10666016wmb.5;
        Mon, 13 Mar 2023 04:29:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678706951;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=aWh1L+aecKzdhSM2563wcUvUMrUfLZ8S1mD5QRwDh+E=;
        b=eObCmCRd5bRHvvXHagrtp1WhYxC8O+iYfhT3uLnTJxJxFjQa+MwDN78rrqmhOsY2UE
         cTrbK7sW35CqIkLT/iTTpepAr/FWvkGTxanvnVcKIWVvO5j61b3ATvPul+/Q3e2H7q7h
         jrUBlm6g6CUEQwKrFQCUBVPCTXlbmf8ERYt64uBcUxW3iUv9Alr6bAYcRY5W7jG0k/6x
         +dJOq5UWjQ8QZtbW6FJUE9OEHKWCEfntPoNIZMDCcyOKThSQkuYLQXfQAIXF6Rb71PT2
         p8TAztgRsM4IhVPqncfkdfUEEN+8lvN1/voA7P/V4AoaqHNN0kzkjjy/0Tg6Ik3owkKG
         tRHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678706951;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aWh1L+aecKzdhSM2563wcUvUMrUfLZ8S1mD5QRwDh+E=;
        b=FTVhbZK0FoYmpbO3tsU6w0XZs/6lV+UMEt2blHz8Ik6+k59veilSdDfT50AA3p5HgT
         ZtBCVR0oMcUkeXpnx+MYyE/tLU60CgBaTKzSei+Z/GZN4k2WDYnzMfrMq3rhU2aFF/t8
         yVS5y222OHi8ProNHIyP2aF3p/+UFgwIwuZpp0SHABNOqFE6gmSfwe2NHLdfHAUvkE9v
         184s4x+hixLZV53xj2J6IN7abfLu5n56OvEUOT2l2cT779Y/wwssretD17WKa8XnX61d
         qav0HGZL3358r+ZFYZyOVQKxV0aGhZdR/cZJxHn4dpECRXsisgk9KSAbEyHwB8RO8Sgg
         vSFQ==
X-Gm-Message-State: AO0yUKW1rDgp1K/KxxFOJiDL/WZg2P4g0PNYYthmeJ8xQYCeBGNU+7Eg
        Q5ReZVaevdigWh2ZJjoJNuk=
X-Google-Smtp-Source: AK7set+0fAMqHxiCCQSGAz9wKpYNuL4HmWLGitFNyio88uZz54Ek5qEqkACVY0rkC4WEX4heyVcCoA==
X-Received: by 2002:a05:600c:1c1f:b0:3eb:2b88:8682 with SMTP id j31-20020a05600c1c1f00b003eb2b888682mr11034003wms.17.1678706950758;
        Mon, 13 Mar 2023 04:29:10 -0700 (PDT)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id u10-20020a05600c00ca00b003eb192787bfsm8770781wmm.25.2023.03.13.04.29.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Mar 2023 04:29:09 -0700 (PDT)
Date:   Mon, 13 Mar 2023 11:46:57 +0300
From:   Dan Carpenter <error27@gmail.com>
To:     Alexander Lobakin <aleksander.lobakin@intel.com>
Cc:     Muhammad Usama Anjum <usama.anjum@collabora.com>,
        Simon Horman <simon.horman@corigine.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Ariel Elior <aelior@marvell.com>,
        Manish Chopra <manishc@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, kernel@collabora.com,
        kernel-janitors@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] qede: remove linux/version.h and linux/compiler.h
Message-ID: <ee08333d-d39d-45c6-9e6e-6328855d3068@kili.mountain>
References: <20230303185351.2825900-1-usama.anjum@collabora.com>
 <20230303155436.213ee2c0@kernel.org>
 <df8a446a-e8a9-3b3d-fd0f-791f0d01a0c9@collabora.com>
 <ZAdoivY94Y5dfOa4@corigine.com>
 <1107bc10-9b14-98f4-3e47-f87188453ce7@collabora.com>
 <8a90dca3-af66-5348-72b9-ac49610f22ce@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8a90dca3-af66-5348-72b9-ac49610f22ce@intel.com>
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 07, 2023 at 06:13:16PM +0100, Alexander Lobakin wrote:
> >> Also, as per the examples above, the target tree, in this case
> >> 'net-next' should be included in the subject.
> > I don't know much about net tree and its location. This is why people use
> 
> Here[0].
> 
> > linux-next for sending patches. I'm not sure about the networking sub
> 
> No, people use the corresponding mailing lists to send and repositories
> to base their patches on.
> 

This is only for networking.

It affect BPF too, I suppose, but I always tell everyone to just send
BPF bug reports instead of patches.  I can keep track of linux-next, net
and net-next.  No one can keep track of all @#$@#$@#$@# 300+ trees.

I really hate this networking requirement but I try really hard to get
it right and still mess up half the time.

regards,
dan carpenter

