Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BE66719CEC1
	for <lists+netdev@lfdr.de>; Fri,  3 Apr 2020 04:48:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390231AbgDCCsl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Apr 2020 22:48:41 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:32978 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731842AbgDCCsk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Apr 2020 22:48:40 -0400
Received: by mail-qk1-f196.google.com with SMTP id v7so6638060qkc.0;
        Thu, 02 Apr 2020 19:48:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=rFHEPtdjZ5uRu/MfAd8MJR6yUrAzCll4i5a9ggqXFxg=;
        b=kzDtbuSdYC51j5/IeCHDH2Xm9w5B0P6D0c6FbnnjPAOFMK+v5Doy/ty21RrC/Je0JE
         oETe6D4EeJdJnRBhVw0rxoCo/DEVCiDBAavUzSO/HYNHo0crf0Do7StaJhdnoiETh2bJ
         63Sc8Be+wnAf+sA5gKMmjNFMebI3ihnMOYLoBGi+m/XmbNEt3GzBadX7QzmLAKypsxOp
         TvasGPLf+NmyF/5lu8LZN5+66sAbvLdpQUDX/v3vq/kulUeTQUUtRUz9Mbg2b/TIQ+PA
         2HO+gm3hD09QTXiom2XNj/cJF4JzFzlkhPjs+6BYIe/iX63OReVxTpHtX5Suv2MZE9DR
         1S8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=rFHEPtdjZ5uRu/MfAd8MJR6yUrAzCll4i5a9ggqXFxg=;
        b=qykIzWEjFWtmpTdnbcsn2r3AqpKP1C3ntUaFjMU/pDLHXXLZw7BQeLeEJS7OnL+dBg
         ywbn47DHemCYGDkJmdE24+EAqBTj6V+P5KKfIY2FXTGoJ4Sp8fJE+IIMTEoWo/Y8YzSr
         QtLdLVGVJvxb+6Ff7IXJfLSurtaQDXfLR/s+fTXtcSFZNf5tHyrTGXgnysTm68XkHN2A
         Wxx/8yliVaS9FUUGN+KEu5Bb99TGONoI/aIHP+b6HaUpK/3obYuqWwxlfh6bXc1UrFdK
         +sOzQL7N2Sj8PeMIzUEiKI6AYfNvIgWegfkh+jQRSbHOgNyZojUWWdOiymNhtNW0NsSv
         uEIA==
X-Gm-Message-State: AGi0PubEPHiFZVnB9unzPboHExLxkRYF6f6FaA2D/6R/nMAorjKhlS8c
        luBd51CKJJIrtYgCAeSGD2U=
X-Google-Smtp-Source: APiQypLrQlpd1eOkqOV7AoFqYAQPc+XGdns5YNxSp0dolka6OpZBhf/LrSbz3TQXLR9OPUQRHKXR3Q==
X-Received: by 2002:a37:aa4c:: with SMTP id t73mr6710012qke.300.1585882118766;
        Thu, 02 Apr 2020 19:48:38 -0700 (PDT)
Received: from localhost.localdomain ([177.220.172.142])
        by smtp.gmail.com with ESMTPSA id p191sm4956346qke.6.2020.04.02.19.48.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Apr 2020 19:48:37 -0700 (PDT)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id 43341C0EBA; Thu,  2 Apr 2020 23:48:35 -0300 (-03)
Date:   Thu, 2 Apr 2020 23:48:35 -0300
From:   "marcelo.leitner@gmail.com" <marcelo.leitner@gmail.com>
To:     Saeed Mahameed <saeedm@mellanox.com>
Cc:     Roi Dayan <roid@mellanox.com>, Paul Blakey <paulb@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Vlad Buslov <vladbu@mellanox.com>,
        Oz Shlomo <ozsh@mellanox.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "leon@kernel.org" <leon@kernel.org>
Subject: Re: [PATCH net] net/mlx5e: limit log messages due to (ovs) probing
 to _once
Message-ID: <20200403024835.GA3547@localhost.localdomain>
References: <d57b95462cccf0f67089c91d3dfd3d1f4c46e9bf.1585872570.git.marcelo.leitner@gmail.com>
 <c4e43a61a8ad7f57e2cb228cc0ba810b68af89cb.camel@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c4e43a61a8ad7f57e2cb228cc0ba810b68af89cb.camel@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 03, 2020 at 02:27:08AM +0000, Saeed Mahameed wrote:
> On Thu, 2020-04-02 at 21:11 -0300, Marcelo Ricardo Leitner wrote:
> > OVS will keep adding such flows, no matter what. They will usually be
> > handled by tc software (or ovs datapath, if skip_sw is used). But the
> > driver is logging these messages for each and every attempt, despite
> > the
> > extack. Note that they weren't rate limited, and a broadcast storm
> > could
> > trigger system console flooding.
> > 
> > Switch these to be _once. It's enough to tell the sysadmin what is
> > happenning, and if anything, the OVS log will have all the errors.
> > 
> 
> ++ mlnx TC stake holders 
> 
> The fact that for all of the suppressed messages we will still have NL
> extack reporting, makes it easier for me to agree with this patch. but
> there is a loss of information since now we will stop printing the
> attribute/params which caused the failure in most of the cases, and it
> will be harder for the user and the developer to understand why these
> attributes are not working .. 

I see.

> 
> I understand it is for debug only but i strongly suggest to not totally
> suppress these messages and maybe just move them to tracepoints buffer
> ? for those who would want to really debug .. 
> 
> we already have some tracepoints implemented for en_tc.c 
> mlx5/core/diag/en_tc_tracepoints.c, maybe we should define a tracepoint
> for error reporting .. 

That, or s/netdev_warn/netdev_dbg/, but both are more hidden to the
user than the _once.

> 
> > Signed-off-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
> 
> net patches must have a "Fixes:" tag

I know that it is strongly recommended, but there is nothing really
broken here. It's a small cleanup to code already there. Now I'm
confused, isn't that what net is meant for, and a Fixes tag would be
an abuse of it here?

> 
> > ---
> >  .../net/ethernet/mellanox/mlx5/core/en_tc.c   | 61 ++++++++++-------
> > --
> >  1 file changed, 32 insertions(+), 29 deletions(-)
> > 
> > diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
> > b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
> > index
> > 438128dde187d7ec58892c2879c6037f807f576f..1182fba3edbb8cf7bd59557b7ec
> > e18765c704186 100644
> > --- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
> > +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
> > @@ -1828,8 +1828,8 @@ enc_opts_is_dont_care_or_full_match(struct
> > mlx5e_priv *priv,
> >  				       opt->length * 4)) {
> >  				NL_SET_ERR_MSG(extack,
> >  					       "Partial match of tunnel
> > options in chain > 0 isn't supported");
> > -				netdev_warn(priv->netdev,
> > -					    "Partial match of tunnel
> > options in chain > 0 isn't supported");
> > +				netdev_warn_once(priv->netdev,
> > +						 "Partial match of
> > tunnel options in chain > 0 isn't supported");
> >  				return -EOPNOTSUPP;
> >  			}
> >  		}
> > @@ -1988,8 +1988,8 @@ static int parse_tunnel_attr(struct mlx5e_priv
> > *priv,
> >  	    !mlx5_eswitch_reg_c1_loopback_enabled(esw)) {
> >  		NL_SET_ERR_MSG(extack,
> >  			       "Chains on tunnel devices isn't
> > supported without register loopback support");
> > -		netdev_warn(priv->netdev,
> > -			    "Chains on tunnel devices isn't supported
> > without register loopback support");
> > +		netdev_warn_once(priv->netdev,
> > +				 "Chains on tunnel devices isn't
> > supported without register loopback support");
> >  		return -EOPNOTSUPP;
> >  	}
> >  
> > @@ -2133,8 +2133,8 @@ static int __parse_cls_flower(struct mlx5e_priv
> > *priv,
> >  	      BIT(FLOW_DISSECTOR_KEY_ENC_IP) |
> >  	      BIT(FLOW_DISSECTOR_KEY_ENC_OPTS))) {
> >  		NL_SET_ERR_MSG_MOD(extack, "Unsupported key");
> > -		netdev_warn(priv->netdev, "Unsupported key used:
> > 0x%x\n",
> > -			    dissector->used_keys);
> > +		netdev_warn_once(priv->netdev, "Unsupported key used:
> > 0x%x\n",
> > +				 dissector->used_keys);
> >  		return -EOPNOTSUPP;
> >  	}
> >  
> > @@ -2484,8 +2484,8 @@ static int parse_cls_flower(struct mlx5e_priv
> > *priv,
> >  		    esw->offloads.inline_mode <
> > non_tunnel_match_level)) {
> >  			NL_SET_ERR_MSG_MOD(extack,
> >  					   "Flow is not offloaded due
> > to min inline setting");
> > -			netdev_warn(priv->netdev,
> > -				    "Flow is not offloaded due to min
> > inline setting, required %d actual %d\n",
> > +			netdev_warn_once(priv->netdev,
> > +					 "Flow is not offloaded due to
> > min inline setting, required %d actual %d\n",
> >  				    non_tunnel_match_level, esw-
> > >offloads.inline_mode);
> >  			return -EOPNOTSUPP;
> >  		}
> > @@ -2885,7 +2885,9 @@ static int alloc_tc_pedit_action(struct
> > mlx5e_priv *priv, int namespace,
> >  		if (memcmp(cmd_masks, &zero_masks, sizeof(zero_masks)))
> > {
> >  			NL_SET_ERR_MSG_MOD(extack,
> >  					   "attempt to offload an
> > unsupported field");
> > -			netdev_warn(priv->netdev, "attempt to offload
> > an unsupported field (cmd %d)\n", cmd);
> > +			netdev_warn_once(priv->netdev,
> > +					 "attempt to offload an
> > unsupported field (cmd %d)\n",
> > +					 cmd);
> >  			print_hex_dump(KERN_WARNING, "mask: ",
> > DUMP_PREFIX_ADDRESS,
> >  				       16, 1, cmd_masks,
> > sizeof(zero_masks), true);
> >  			err = -EOPNOTSUPP;
> > @@ -2912,17 +2914,17 @@ static bool csum_offload_supported(struct
> > mlx5e_priv *priv,
> >  	if (!(action & MLX5_FLOW_CONTEXT_ACTION_MOD_HDR)) {
> >  		NL_SET_ERR_MSG_MOD(extack,
> >  				   "TC csum action is only offloaded
> > with pedit");
> > -		netdev_warn(priv->netdev,
> > -			    "TC csum action is only offloaded with
> > pedit\n");
> > +		netdev_warn_once(priv->netdev,
> > +				 "TC csum action is only offloaded with
> > pedit\n");
> >  		return false;
> >  	}
> >  
> >  	if (update_flags & ~prot_flags) {
> >  		NL_SET_ERR_MSG_MOD(extack,
> >  				   "can't offload TC csum action for
> > some header/s");
> > -		netdev_warn(priv->netdev,
> > -			    "can't offload TC csum action for some
> > header/s - flags %#x\n",
> > -			    update_flags);
> > +		netdev_warn_once(priv->netdev,
> > +				 "can't offload TC csum action for some
> > header/s - flags %#x\n",
> > +				 update_flags);
> >  		return false;
> >  	}
> >  
> > @@ -3224,8 +3226,9 @@ static int parse_tc_nic_actions(struct
> > mlx5e_priv *priv,
> >  			} else {
> >  				NL_SET_ERR_MSG_MOD(extack,
> >  						   "device is not on
> > same HW, can't offload");
> > -				netdev_warn(priv->netdev, "device %s
> > not on same HW, can't offload\n",
> > -					    peer_dev->name);
> > +				netdev_warn_once(priv->netdev,
> > +						 "device %s not on same
> > HW, can't offload\n",
> > +						 peer_dev->name);
> >  				return -EINVAL;
> >  			}
> >  			}
> > @@ -3754,9 +3757,9 @@ static int parse_tc_fdb_actions(struct
> > mlx5e_priv *priv,
> >  			if (attr->out_count >=
> > MLX5_MAX_FLOW_FWD_VPORTS) {
> >  				NL_SET_ERR_MSG_MOD(extack,
> >  						   "can't support more
> > output ports, can't offload forwarding");
> > -				netdev_warn(priv->netdev,
> > -					    "can't support more than %d
> > output ports, can't offload forwarding\n",
> > -					    attr->out_count);
> > +				netdev_warn_once(priv->netdev,
> > +						 "can't support more
> > than %d output ports, can't offload forwarding\n",
> > +						 attr->out_count);
> >  				return -EOPNOTSUPP;
> >  			}
> >  
> > @@ -3821,10 +3824,10 @@ static int parse_tc_fdb_actions(struct
> > mlx5e_priv *priv,
> >  				if
> > (!mlx5e_is_valid_eswitch_fwd_dev(priv, out_dev)) {
> >  					NL_SET_ERR_MSG_MOD(extack,
> >  							   "devices are
> > not on same switch HW, can't offload forwarding");
> > -					netdev_warn(priv->netdev,
> > -						    "devices %s %s not
> > on same switch HW, can't offload forwarding\n",
> > -						    priv->netdev->name,
> > -						    out_dev->name);
> > +					netdev_warn_once(priv->netdev,
> > +							 "devices %s %s
> > not on same switch HW, can't offload forwarding\n",
> > +							 priv->netdev-
> > >name,
> > +							 out_dev-
> > >name);
> >  					return -EOPNOTSUPP;
> >  				}
> >  
> > @@ -3843,10 +3846,10 @@ static int parse_tc_fdb_actions(struct
> > mlx5e_priv *priv,
> >  			} else {
> >  				NL_SET_ERR_MSG_MOD(extack,
> >  						   "devices are not on
> > same switch HW, can't offload forwarding");
> > -				netdev_warn(priv->netdev,
> > -					    "devices %s %s not on same
> > switch HW, can't offload forwarding\n",
> > -					    priv->netdev->name,
> > -					    out_dev->name);
> > +				netdev_warn_once(priv->netdev,
> > +						 "devices %s %s not on
> > same switch HW, can't offload forwarding\n",
> > +						 priv->netdev->name,
> > +						 out_dev->name);
> >  				return -EINVAL;
> >  			}
> >  			}
> > @@ -3959,8 +3962,8 @@ static int parse_tc_fdb_actions(struct
> > mlx5e_priv *priv,
> >  
> >  			NL_SET_ERR_MSG(extack,
> >  				       "Decap with goto isn't
> > supported");
> > -			netdev_warn(priv->netdev,
> > -				    "Decap with goto isn't supported");
> > +			netdev_warn_once(priv->netdev,
> > +					 "Decap with goto isn't
> > supported");
> >  			return -EOPNOTSUPP;
> >  		}
> >  
