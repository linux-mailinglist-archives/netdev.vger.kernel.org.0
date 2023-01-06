Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDA1E65FD39
	for <lists+netdev@lfdr.de>; Fri,  6 Jan 2023 09:59:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232339AbjAFI6u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Jan 2023 03:58:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232942AbjAFI6G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Jan 2023 03:58:06 -0500
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CEE715F34
        for <netdev@vger.kernel.org>; Fri,  6 Jan 2023 00:57:26 -0800 (PST)
Received: by mail-pl1-x635.google.com with SMTP id d15so1065512pls.6
        for <netdev@vger.kernel.org>; Fri, 06 Jan 2023 00:57:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=JirnD06X36ebl8jLkEsnYs3m2jX3vu0wsY5jTd8woWM=;
        b=tigXq1OqtE+aIy4IHiU6KZ1+OmLPLf4TP67FcVQwSBuVZOnRlVtrpUceJNqc26QkDs
         DyG4YS0smf5muUjtTPx2sp/LAyVpzpkpWKoAty50zAKmyXMlII4+/qwXKrRZCeb//ILe
         eRAGYjRploXPYrt3//utZ1eX6tCGENirYNHWSCz1sXyTLtnuQt+dEIU5y5rdxu67TiVU
         64k7ZMqn2uxK+hEiSXc+15BOF0MO7gAO3T+mkcECpbAgoJvQ9yG6ySFwphfaahDDjHIH
         tvSNvsA7WTwRWD9ZnssNMLDtUt9obW5LO5baj/PJlPJbftQXSx4hq3IeY5TwLkdSM+Kh
         3k6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JirnD06X36ebl8jLkEsnYs3m2jX3vu0wsY5jTd8woWM=;
        b=lOzvH7LznAxfqUyDgVRiPnooIuVBPgEMK4chg4HG8VNsdPET84IdU/H2VP1+eoASL1
         A7f0ujqXWeiM8TfX/eOoTmZbFJJCb7DiAbCU9b8W7/tg9ZMTFYMsHJhDo7K86XJZwt7G
         nsu6xA0vok2w7XowuC6W4FJjR/hG8KTtFcCnCpoa4Q8F5OKSkpKIfvAYDDEh0phEqJU7
         Ryk/3izqUmiJfw2Kyr8wsqCPObMg2/M/JBcHF/ADWFdQ13TghHie5CwqAO7jNNuR61J9
         GFpyeezp0lb0bUcofHEEaH7vgg4zIh7aVxg47lYpECHqNuNmk0HkgACtkvXaWOuTBQqt
         gJQQ==
X-Gm-Message-State: AFqh2koMbWiHUp7e4cXMAt1wHumamOKdBnT/i8QN0GZwX/Xr4D7mn4lb
        FYQn9/sjTPdkoglRi8/lpmFQMA==
X-Google-Smtp-Source: AMrXdXs8SrVYyLzbzpgf1DwMxtTL4goJEEWFnYvAB4p4Mx+YaNyQIKxq1+vR9KUO9+IP6mVqQNcu0A==
X-Received: by 2002:a17:903:2c5:b0:192:cf35:3ff8 with SMTP id s5-20020a17090302c500b00192cf353ff8mr18401693plk.21.1672995445732;
        Fri, 06 Jan 2023 00:57:25 -0800 (PST)
Received: from localhost (thunderhill.nvidia.com. [216.228.112.22])
        by smtp.gmail.com with ESMTPSA id m11-20020a170902f20b00b00189fdadef9csm439908plc.107.2023.01.06.00.57.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Jan 2023 00:57:25 -0800 (PST)
Date:   Fri, 6 Jan 2023 09:57:22 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, jacob.e.keller@intel.com
Subject: Re: [PATCH net-next v2 03/15] devlink: split out core code
Message-ID: <Y7ficgENA1lbb8gn@nanopsycho>
References: <20230105040531.353563-1-kuba@kernel.org>
 <20230105040531.353563-4-kuba@kernel.org>
 <Y7aVeL0QlqiM8sOq@nanopsycho>
 <20230105103428.65a4e916@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230105103428.65a4e916@kernel.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, Jan 05, 2023 at 07:34:28PM CET, kuba@kernel.org wrote:
>On Thu, 5 Jan 2023 10:16:40 +0100 Jiri Pirko wrote:
>> Btw, I don't think it is correct to carry Jacob's review tag around when
>> the patches changed (not only this one).
>
>There's no clear rule for that :(  I see more people screaming 
>at submitters for dropping tags than for keeping them so I err 
>on that side myself.
>
>Here I think the case is relatively clear, since I'm only doing
>renames and bike-shedding stuff, and Jake is not one to bike-shed 
>in my experience.

Okay.
