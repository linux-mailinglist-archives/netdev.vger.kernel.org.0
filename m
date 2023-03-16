Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD2F46BC35F
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 02:38:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229797AbjCPBiu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 21:38:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229487AbjCPBit (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 21:38:49 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B45567707
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 18:38:48 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id rj10so207729pjb.4
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 18:38:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112; t=1678930728;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3AFsNWCEt4Tra7IYWsq0la2F6kxqXukdmZeCb1dGw+g=;
        b=Wx3pja8dNPlAc+jli798ffqGzlhCxObRdSSMKM/ln1oAAICe5yxLrv3+eS0H96FUAD
         XlrFuArrhQqpLHJdk9NR3jQb0OCWdnPhkeLIpewg7ghTnVETdEDV5jAQe2W1zoDr+bv/
         GOOhCwL3AHwsKgcZ3piUIIweDB0aRsHfJV7Pg6AEAME1kW7luzMjSXgvIpt5HyBkuE/n
         pcFHVSigLjlagUkW3dUk7xx+cPB97+dfq4yPLVdCwaSCa6hCUfjsZq2XoQSuB5pg81qe
         5Qkaj8ieBPR2MIdKKWWa0h9K6dVw+Ojaykp4l+nmNQqXdYsa6dVZwXy28JCCbO5h2plm
         F7Cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678930728;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3AFsNWCEt4Tra7IYWsq0la2F6kxqXukdmZeCb1dGw+g=;
        b=i9QkO4/08DlbzE0kc8XbbwU05FKhKE+pNyf5EI7fiWnPwBcF57VDWm0aTwaKsNr5EP
         6IFMcLJGMflDMMJOZOc/hXTal3HVlZnP2JdCaQFNZHgv6rgWNf3jmmF0hvqHruBUUnE+
         kaZNZXIsSXaR4HcE1k9qUf6K2YB9/saM+Pykjc+ewiv4tZ7SRvVxiODOcQfi1L2Dkuds
         AuyI1WyZWeiRrWR9/hNedpmQvaUtJkW8pJ5G+9N7iTlSJ/NunIu5t1eK4ZzS3aNdEP9D
         uo7Uqx0nQ/qF6kCHD9eFZ6qWEtJPcX3LoXtglB0CT3f0M8nZHL2x8NVWXr6zug5O8GE5
         6b+Q==
X-Gm-Message-State: AO0yUKWECkhmpn0qpl9CABiahWuXcrFAFqWIOeE7kDstBfpAtbfJoAkS
        ul+ZuN77/cnifk+ThQZmjHF/LQ==
X-Google-Smtp-Source: AK7set/tHS/PFlmJd1WPqOmIpYWDDjKvUkdT2AhlMOza4pCnAs1vjpmSCnLyORYBs+6ytqo8kFnuJw==
X-Received: by 2002:a17:902:fa47:b0:19e:6700:174 with SMTP id lb7-20020a170902fa4700b0019e67000174mr1319506plb.25.1678930728138;
        Wed, 15 Mar 2023 18:38:48 -0700 (PDT)
Received: from hermes.local (204-195-120-218.wavecable.com. [204.195.120.218])
        by smtp.gmail.com with ESMTPSA id kb5-20020a170903338500b0019a6cce2060sm4271020plb.57.2023.03.15.18.38.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Mar 2023 18:38:47 -0700 (PDT)
Date:   Wed, 15 Mar 2023 18:38:46 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, jesse.brandeburg@intel.com,
        anthony.l.nguyen@intel.com, corbet@lwn.net,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH net-next] docs: networking: document NAPI
Message-ID: <20230315183846.3eb99271@hermes.local>
In-Reply-To: <20230315223044.471002-1-kuba@kernel.org>
References: <20230315223044.471002-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 15 Mar 2023 15:30:44 -0700
Jakub Kicinski <kuba@kernel.org> wrote:

> Add basic documentation about NAPI. We can stop linking to the ancient
> doc on the LF wiki.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
> CC: jesse.brandeburg@intel.com
> CC: anthony.l.nguyen@intel.com
> CC: corbet@lwn.net
> CC: linux-doc@vger.kernel.org

Older pre LF wiki NAPI docs still survive here
https://lwn.net/2002/0321/a/napi-howto.php3
