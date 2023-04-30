Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFFB86F2982
	for <lists+netdev@lfdr.de>; Sun, 30 Apr 2023 18:33:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229531AbjD3QdU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Apr 2023 12:33:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbjD3QdT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 30 Apr 2023 12:33:19 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F97C1992
        for <netdev@vger.kernel.org>; Sun, 30 Apr 2023 09:33:18 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id a640c23a62f3a-95369921f8eso279007066b.0
        for <netdev@vger.kernel.org>; Sun, 30 Apr 2023 09:33:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20221208; t=1682872397; x=1685464397;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=36vDHEyhgdmoEKEhZBWydaczC5wXTGynJAiuLeVEt24=;
        b=kknT0Aqe6to5Rl7cg9AVJd4P7g6CogvrLoY2mFFbgCSJiSXY99VP4juNA2k0Ji5huB
         822nZfB4r/gjKshns0OlJdG8sNuLApJDWbvq9dP22QtocillNiojVOty4NTxO33yKfYV
         9rn996mmb0oCFHVH10DmTFbKveYkDLujJfY+7tnx9ZCDCOr/HRfJIlNr5TX1q0V5QYyB
         8E2BVrMRuc2rQdBqMwWN1qnmRfJ9cXzojqkkfXxpLKPNqINzAGRTDvqWNV4/2NjsBINf
         lemGYoiu+THDXcoWgodWds2RKRd00MZxaYKBS+d0gzzbgr+lRxNuFxpQ2m2loOtMNI4n
         t/gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682872397; x=1685464397;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=36vDHEyhgdmoEKEhZBWydaczC5wXTGynJAiuLeVEt24=;
        b=Eddx6SszNffRwoYi+UhMQChgVqPle/NdcoY9BqtZCb3JhlNBJC+OvN2keGhijlkQgV
         ndkuQ+RZhIBF6xnV1HyKh9SpCrHiDipdwA2vfcZKr4T8Aat6JEDOvMwWGmlZgKiSkC4D
         edxnN72RerdeuEH/8FCdAcVjccuX0osRfT89Y5oovlQHicdTjCVxsnRAACgLyDOh0TsJ
         vQrvuBmziRG519CDA6xZ1q4eqRAa+Rw7Kr/zWkonsUdrbF4UOlT+fLoAZvt88Wp2qlZD
         9FBJ2jEvGGzagdMsXuwAEAptlikD+FNK65i0O8STqWTpTXVtU/RXBeA7hbkRgJHL8Bb4
         YxrA==
X-Gm-Message-State: AC+VfDzxrR3ZS6LKjPhMC4ZFd1cEHPvf92xOgAO/bi8MStmLViPPZzOu
        9MX6ktcmexX0b+qkTeZUA9U=
X-Google-Smtp-Source: ACHHUZ77ueUidRSxScliQynGR+v7CKEBDzQOck0R6IkIjk/7bYrYmNlorSuMymNEV2qSLRsU+eZL0Q==
X-Received: by 2002:a17:907:3faa:b0:94f:695e:b0c9 with SMTP id hr42-20020a1709073faa00b0094f695eb0c9mr11139149ejc.5.1682872396725;
        Sun, 30 Apr 2023 09:33:16 -0700 (PDT)
Received: from tycho (p200300c1c74c0400ba8584fffebf2b17.dip0.t-ipconnect.de. [2003:c1:c74c:400:ba85:84ff:febf:2b17])
        by smtp.gmail.com with ESMTPSA id rv13-20020a1709068d0d00b0095952f1b1b7sm10028909ejc.201.2023.04.30.09.33.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 30 Apr 2023 09:33:16 -0700 (PDT)
Sender: Zahari Doychev <zahari.doychev@googlemail.com>
Date:   Sun, 30 Apr 2023 18:33:14 +0200
From:   Zahari Doychev <zahari.doychev@linux.com>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, hmehrtens@maxlinear.com,
        aleksander.lobakin@intel.com, simon.horman@corigine.com,
        Zahari Doychev <zdoychev@maxlinear.com>
Subject: Re: [PATCH net-next v4 1/3] net: flow_dissector: add support for cfm
 packets
Message-ID: <seeyto2k7ifi34xxbkty5nhii3hl3m5pppt3undqy6atbuup5n@hbqaxen26ch3>
References: <20230425211630.698373-1-zahari.doychev@linux.com>
 <20230425211630.698373-2-zahari.doychev@linux.com>
 <ZE577xtGlv3fjTF2@shredder>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZE577xtGlv3fjTF2@shredder>
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


[...] 
> >  
> > +/**
> > + * struct flow_dissector_key_cfm
> > + * @mdl_ver: maintenance domain level(mdl) and cfm protocol version
>                                         ^ missing space
> 
> > + * @opcode: code specifying a type of cfm protocol packet

[...]

 > +	key->opcode = hdr->opcode;
> > +
> > +	return  FLOW_DISSECT_RET_OUT_GOOD;
>               ^ double space
> 
> > +}
> > +
> >  static enum flow_dissect_ret
> >  __skb_flow_dissect_gre(const struct sk_buff *skb,
> >  		       struct flow_dissector_key_control *key_control,
> > @@ -1390,6 +1414,12 @@ bool __skb_flow_dissect(const struct net *net,
> >  		break;
> >  	}
> >  
> > +	case htons(ETH_P_CFM): {
> > +		fdret = __skb_flow_dissect_cfm(skb, flow_dissector,
> > +					       target_container, data,
> > +					       nhoff, hlen);
> > +		break;
> > +	}
> 
> No variables are declared, drop the braces?
> 

thanks, I will fix them for the next series.

> >  	default:
> >  		fdret = FLOW_DISSECT_RET_OUT_BAD;
> >  		break;
> > -- 
> > 2.40.0
> > 
