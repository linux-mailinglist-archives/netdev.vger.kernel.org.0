Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76E1E68703C
	for <lists+netdev@lfdr.de>; Wed,  1 Feb 2023 21:59:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229849AbjBAU7S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Feb 2023 15:59:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229551AbjBAU7R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Feb 2023 15:59:17 -0500
Received: from mail-oa1-x31.google.com (mail-oa1-x31.google.com [IPv6:2001:4860:4864:20::31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C429198
        for <netdev@vger.kernel.org>; Wed,  1 Feb 2023 12:59:15 -0800 (PST)
Received: by mail-oa1-x31.google.com with SMTP id 586e51a60fabf-15ff0a1f735so25257572fac.5
        for <netdev@vger.kernel.org>; Wed, 01 Feb 2023 12:59:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=RZGlcq3Wvoegd4phO3vsTT5JRCo9OlPxWMiQJoMlqjg=;
        b=7lvkPefbtwR6TGwcL0/sroWrqFIC6CgNCF71+c12782/g1Gmy5aRjJfwQohIlen02D
         NPtYOTsr0MJ62VjTkonpaaEva93cV/p0Ih9jpzPIy91gnrSAulZ1o7KVKtRVvNrmWlbl
         xYk7skohIFVykhDc5hlNMT+0g+h86X/AOdUVRm1RFrh0rG6FfYeEc23/LBnhD6vgUkCg
         m+YAe3EkB0kLBmT2GvcBBGAF2cQhv26jCTGTI2qSoU6qwNwyWv369m00MEtC640PIY7j
         k6xEwJzdD0fn+qTnXXvy1lp4sEQgt6yA1O4kkv90MniCqvqT3R9ihL8pP47808IgW39F
         IbPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RZGlcq3Wvoegd4phO3vsTT5JRCo9OlPxWMiQJoMlqjg=;
        b=OakKPzO/bvblfz1YJsqcI5QIYQy3GocATj/Udjeqgu+cPbf2JwxaNxDeQ9aGquejn4
         +KhvzrzflcatYc35nr0n3bLojUILvlyMFAFeb6JFsrzjCoV0mc42ItF2U/48tIQkaoaz
         0yt3OCGkv4Zqc+fv4siYdEdcVYDDFMNsTZH11fzgu3l9jv4pLOwTqc8gTEmz7+dj9V6M
         ctOiqdRywvVIt4F/sJOZ7QUbtyt6BhduZHFqPU9TfU3PFdldWvpcDzGr1pvGSfc5e/8U
         OXsjGGX2xQ9MA/NgeI4yRo6D78yUZMz+0tj6Yr2QQ445vD7nFtoWSONniFt8/jL3cVTg
         X4XQ==
X-Gm-Message-State: AO0yUKUMomndQHnv9iqLaS4lKwXC2A3cgLHnhMRKizayVRQCt+FvgRFC
        Nrbp44hQ6CqlP7OIBDUp3EdHsA==
X-Google-Smtp-Source: AK7set+ywipzyTVdmtL1bpsII57yPG0E01H1Rw7LldiE9FBBLDr8IgS3ZHF3qOXsztWcnMmfnqMLjw==
X-Received: by 2002:a05:6870:4602:b0:163:92dd:a16b with SMTP id z2-20020a056870460200b0016392dda16bmr1678968oao.48.1675285154983;
        Wed, 01 Feb 2023 12:59:14 -0800 (PST)
Received: from ?IPV6:2804:14d:5c5e:4698:aee4:e149:a30a:c8ca? ([2804:14d:5c5e:4698:aee4:e149:a30a:c8ca])
        by smtp.gmail.com with ESMTPSA id m6-20020a9d4c86000000b0068d3f341dd9sm1280580otf.62.2023.02.01.12.59.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Feb 2023 12:59:14 -0800 (PST)
Message-ID: <a32d4a16-90d9-06b5-c56f-aaa4304795e5@mojatatu.com>
Date:   Wed, 1 Feb 2023 17:59:10 -0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH net-next 2/9] net/sched: act_pedit, setup offload action
 for action stats query
Content-Language: en-US
To:     Oz Shlomo <ozsh@nvidia.com>, netdev@vger.kernel.org
Cc:     Saeed Mahameed <saeedm@nvidia.com>, Roi Dayan <roid@nvidia.com>,
        Jiri Pirko <jiri@nvidia.com>,
        Marcelo Ricardo Leitner <mleitner@redhat.com>,
        Simon Horman <simon.horman@corigine.com>,
        Baowen Zheng <baowen.zheng@corigine.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Edward Cree <ecree.xilinx@gmail.com>
References: <20230201161039.20714-1-ozsh@nvidia.com>
 <20230201161039.20714-3-ozsh@nvidia.com>
From:   Pedro Tammela <pctammela@mojatatu.com>
In-Reply-To: <20230201161039.20714-3-ozsh@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 01/02/2023 13:10, Oz Shlomo wrote:
> A single tc pedit action may be translated to multiple flow_offload
> actions.
> Offload only actions that translate to a single pedit command value.
> 
> Signed-off-by: Oz Shlomo <ozsh@nvidia.com>
> ---
>   net/sched/act_pedit.c | 24 +++++++++++++++++++++++-
>   1 file changed, 23 insertions(+), 1 deletion(-)
> 
> diff --git a/net/sched/act_pedit.c b/net/sched/act_pedit.c
> index a0378e9f0121..abceef794f28 100644
> --- a/net/sched/act_pedit.c
> +++ b/net/sched/act_pedit.c
> @@ -522,7 +522,29 @@ static int tcf_pedit_offload_act_setup(struct tc_action *act, void *entry_data,
>   		}
>   		*index_inc = k;
>   	} else {
> -		return -EOPNOTSUPP;
> +		struct flow_offload_action *fl_action = entry_data;
> +		u32 last_cmd;
> +		int k;
> +
> +		for (k = 0; k < tcf_pedit_nkeys(act); k++) {
> +			u32 cmd = tcf_pedit_cmd(act, k);
> +
> +			if (k && cmd != last_cmd)
> +				return -EOPNOTSUPP;

I believe an extack message here is very valuable

> +
> +			last_cmd = cmd;
> +			switch (cmd) {
> +			case TCA_PEDIT_KEY_EX_CMD_SET:
> +				fl_action->id = FLOW_ACTION_MANGLE;
> +				break;
> +			case TCA_PEDIT_KEY_EX_CMD_ADD:
> +				fl_action->id = FLOW_ACTION_ADD;
> +				break;
> +			default:
> +				NL_SET_ERR_MSG_MOD(extack, "Unsupported pedit command offload");
> +				return -EOPNOTSUPP;
> +			}
> +		}

Shouldn't this switch case be outside of the for-loop?

>   	}
>   
>   	return 0;

